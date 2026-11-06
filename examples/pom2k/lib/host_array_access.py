#!/usr/bin/env python3
"""Reports host-side accesses to a kernel's array arguments in lowered GPU code.

The GPU harnesses can pass device buffers to the lowered entry point only if
its host code never loads from or stores to the argument arrays (all such
accesses must have been moved into kernels, which is what scf-offload-host-loops
does). This checks the textual LLVM IR of the entry point: every load/store
pointer is traced back through getelementptr/bitcast/select/phi to its bases;
a base that is a function argument is a host access. Loads through globals
(the harness's scalar globals such as @im) are fine, and so are i32 accesses:
the only i32 arguments are the 1-element branch selectors (iext, isplit, nbc;
generate_benchmarks.py rejects any other), which the harnesses keep in
host-accessible managed memory.

Usage: host_array_access.py <lowered .ll> <entry function name>
Exit code 0: no host access to argument arrays; 1: accesses found (listed on
stdout); 2: usage error or entry point not found.
"""
import re
import sys


def entry_body(text, name):
    m = re.search(r'^define [^\n]*@' + re.escape(name) + r'\((.*?)\)[^\n]*\{\n(.*?)^\}',
                  text, re.S | re.M)
    if not m:
        return None, None
    params = re.findall(r'(%[\w.]+)\s*(?:,|$)', m.group(1))
    return set(params), m.group(2)


def main():
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    text = open(sys.argv[1]).read()
    params, body = entry_body(text, sys.argv[2])
    if body is None:
        print(f"entry point @{sys.argv[2]} not found", file=sys.stderr)
        return 2

    # Pointer value -> the pointer operands it is derived from (indices and
    # conditions are not followed).
    ref = r'(%[\w.]+|@[\w.$]+)'
    derives = {}
    for line in body.splitlines():
        m = re.match(r'\s*(%[\w.]+) = (getelementptr|bitcast|addrspacecast|select|phi)\b(.*)', line)
        if not m:
            continue
        op, rest = m.group(2), m.group(3)
        if op == "phi":
            if re.match(r'\s*ptr\b', rest):
                derives[m.group(1)] = re.findall(r'\[\s*' + ref, rest)
        elif op == "select":
            derives[m.group(1)] = re.findall(r'\bptr ' + ref, rest)
        else:
            first = re.search(r'\bptr ' + ref, rest)
            if first:
                derives[m.group(1)] = [first.group(1)]

    def bases(value, seen):
        if value in seen:
            return set()
        seen.add(value)
        if value not in derives:
            return {value}
        out = set()
        for v in derives[value]:
            out |= bases(v, seen)
        return out

    hits = []
    for line in body.splitlines():
        m = (re.match(r'\s*(?:%[\w.]+ = )?load ([^,]+), ptr (%[\w.]+|@[\w.$]+)', line) or
             re.match(r'\s*store (\S+) [^,]+, ptr (%[\w.]+|@[\w.$]+)', line))
        if m and m.group(1).strip() != "i32" and bases(m.group(2), set()) & params:
            hits.append(line.strip())
    for h in hits:
        print(h)
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())
