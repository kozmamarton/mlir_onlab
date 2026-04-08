import json
import re
import argparse


class Colors:
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    RESET = '\033[0m'


def c(text, color):
    return (f"{color}{text}{Colors.RESET}")


def extract_c_function_names(file_content):
    """Extract a list of C function names from the file content."""
    function_pattern = r'\b[_a-zA-Z][_a-zA-Z0-9]*\s+(ext_[_a-zA-Z0-9]+)\s*\('
    matches = re.finditer(function_pattern, file_content)

    function_names = [match.group(1) for match in matches]
    return function_names


def extract_c_functions(file_content):
    """Extract a list of C function definitions from the file content."""
    function_pattern = r'\b([_a-zA-Z][_a-zA-Z0-9]*)\b\s+([_a-zA-Z][_a-zA-Z0-9]*)\s*\(([^)]*)\)\s*\{'
    matches = re.finditer(function_pattern, file_content, re.MULTILINE)

    functions = []
    for match in matches:
        start_brace = file_content.find('{', match.start())
        brace_count = 1
        end = start_brace

        # Find the matching closing brace
        while brace_count > 0 and end < len(file_content):
            end += 1
            if file_content[end] == '{':
                brace_count += 1
            elif file_content[end] == '}':
                brace_count -= 1

        # Extract the function code
        function_code = file_content[start_brace:end+1]
        functions.append(function_code)

    return functions


def find_function(file_content, function_name):
    """Find the function in the file content."""
    function_start = file_content.find(function_name)
    if function_start == -1:
        return None

    # Find the opening brace of the function
    brace_start = file_content.find('{', function_start)
    if brace_start == -1:
        return None

    # Count braces to find the end of the function
    brace_count = 1
    for end in range(brace_start + 1, len(file_content)):
        if file_content[end] == '{':
            brace_count += 1
        elif file_content[end] == '}':
            brace_count -= 1
            if brace_count == 0:
                return file_content[brace_start:end + 1]
    return None


def extract_loop_nests(function_code):
    """Extract separate nested loop structures in the function and save them into an array."""
    loop_nests = []
    current_nest = []
    nest_level = 0
    lines = function_code.split('\n')

    for line in lines:
        stripped_line = line.strip()

        # Check if the line is the start of a for loop
        if stripped_line.startswith('for') and '{' in stripped_line:
            if nest_level == 0:
                # Start a new nest if we are not already in a loop
                current_nest = [line]
            else:
                # Otherwise, add the line to the current nest
                current_nest.append(line)
            nest_level += 1
        elif nest_level > 0:
            # Add all lines within the loop nest
            current_nest.append(line)
            if '}' in stripped_line:
                nest_level -= 1
                if nest_level == 0:
                    # End of the top-level loop, save the current nest
                    loop_nests.append(current_nest)
                    current_nest = []

    return loop_nests


def count_for_loop_nests(function_code):
    """Count the number of separate nested loop structures in the function."""
    loop_nest_count = 0
    nest_level = 0
    lines = function_code.split('\n')

    for line in lines:
        stripped_line = line.strip()

        # Detect entering a new top-level for loop
        if stripped_line.startswith('for') and '{' in stripped_line:
            if nest_level == 0:
                loop_nest_count += 1
            nest_level += 1

        # Detect exiting a for loop
        if '}' in stripped_line:
            nest_level -= 1

    return loop_nest_count


def read_json(file_path):
    """Read the JSON file."""
    try:
        with open(file_path, 'r') as file:
            json_content = json.load(file)
        return json_content
    except FileNotFoundError:
        # print(f"File '{file_path}' not found.")
        return None


def process_file(file_path, function_name):
    """Process the file to find the function and count for loop nests."""
    with open(file_path, 'r') as file:
        file_content = file.read()

    function_code = find_function(file_content, function_name)

    function_json = read_json(f'./json/{function_name}.json')

    if function_json is None:
        return

    if function_code:
        # nests = count_for_loop_nests(function_code)
        extracted = extract_loop_nests(function_code)

        nests = len(extracted)

        if (len(function_json['loops']) ==
                nests):
            print(c(f"Function '{function_name}' verified.", Colors.GREEN))
        else:
            print(c(f"Function '{function_name}' not verified.", Colors.RED))
            print(
                f"    {c('-->', Colors.BLUE)} Found: {c(nests, Colors.MAGENTA)}")
            print(
                f"    {c('-->', Colors.BLUE)} JSON: {c(len(function_json['loops']), Colors.YELLOW)}")
        # print(
        # f"Number of for loop nests in function '{function_name}': {nests}")

        # for i, nest in enumerate(extracted):
        #     print(f"Loop nest {i}:")
        #     for line in nest:
        #         print(line)
        #     print("-" * 80)
    else:
        print(f"Function '{function_name}' not found.")


parser = argparse.ArgumentParser()
parser.add_argument('functions', nargs='*',
                    help='Functions to convert', default=[])
options = parser.parse_args()

# Example usage
file_path = './pom2k_fun.c'


if len(options.functions) == 0:
    with open(file_path, 'r') as file:
        file_content = file.read()
        functions = extract_c_function_names(file_content)
        # sort
        functions = sorted(functions)
        for func in functions:
            process_file(file_path, func)
else:
    function_name = options.functions[0]
    process_file(file_path, function_name)
