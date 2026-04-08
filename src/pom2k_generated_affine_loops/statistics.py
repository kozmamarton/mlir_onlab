import os
import json

# Define the directory containing the JSON files
script_dir = os.path.dirname(__file__)
json_directory = os.path.join(script_dir, 'json')

loops = {}

# Check if the directory exists
if not os.path.exists(json_directory):
    print(f"The directory {json_directory} does not exist.")
else:
    # Loop through each file in the directory
    for filename in os.listdir(json_directory):
        # Check for .json extension
        if filename.endswith('.json'):
            # Construct the full file path
            file_path = os.path.join(json_directory, filename)
            try:
                # Open and read the JSON file
                all_args = []
                with open(file_path, 'r') as json_file:
                    data = json.load(json_file)
                    # Extract the "loops" field
                    loops_data = data.get("loops", None)
                    
                    lines_data = data.get("lines", None)
                    
#                       "lines": {
#     "body_end": 2454,
#     "body_start": 2248,
#     "end": 2455,
#     "start": 2244
#   },
                    loc = 0
                    # calculate loc 
                    if lines_data is not None:
                        loc = lines_data['body_end'] - lines_data['body_start']
                        
                        
                        

                    if loops_data is not None:
                        loops[filename] = {
                            'loop_count': len(loops_data),
                            'args': sum(map(lambda x: len(x['args']), loops_data)),
                            # read_args: x['args'] where write is False and read is True
                            'read_args': sum(map(lambda x: len(list(filter(lambda y: y['read'] and not y['write'], x['args']))), loops_data)),
                            'write_args': sum(map(lambda x: len(list(filter(lambda y: y['write'] and not y['read'], x['args']))), loops_data)),
                            'read_write_args': sum(map(lambda x: len(list(filter(lambda y: y['write'] and y['read'], x['args']))), loops_data)),
                            'constants': sum(map(lambda x: len(x['constants']), loops_data)),
                            'locals': sum(map(lambda x: len(x['locals']), loops_data)),
                            '1d_loop_count': len(list(filter(lambda x: x['size'] == 1, loops_data))),
                            '2d_loop_count': len(list(filter(lambda x: x['size'] == 2, loops_data))),
                            '3d_loop_count': len(list(filter(lambda x: x['size'] == 3, loops_data))),
                            'distinct_args': len(set(map(lambda x: x['name'], sum(map(lambda x: x['args'], loops_data), [])))),
                            'loc': loc
                        }

                    else:
                        print(
                            f'File: {filename} does not contain "loops" field.')
            except json.JSONDecodeError as e:
                print(f'An error occurred while parsing {filename}: {e}')
            except Exception as e:
                print(f'An error occurred while processing {filename}: {e}')


functions_count = len(loops)
loops_count = sum(map(lambda x: x['loop_count'], loops.values()))
d1_loops_count = sum(map(lambda x: x['1d_loop_count'], loops.values()))
d2_loops_count = sum(map(lambda x: x['2d_loop_count'], loops.values()))
d3_loops_count = sum(map(lambda x: x['3d_loop_count'], loops.values()))
constants_count = sum(map(lambda x: x['constants'], loops.values()))
locals_count = sum(map(lambda x: x['locals'], loops.values()))
args_count = sum(map(lambda x: x['args'], loops.values()))
read_args_count = sum(map(lambda x: x['read_args'], loops.values()))
write_args_count = sum(map(lambda x: x['write_args'], loops.values()))
read_write_args_count = sum(
    map(lambda x: x['read_write_args'], loops.values()))

# loc 
loc_count = sum(map(lambda x: x['loc'], loops.values()))

 # Assuming each


# distinct_args_write = []
# distinct_args_read = []
# distinct_args_read_write = []




# for arg in all_args:
#     if arg['write'] and not arg['read']:
#         distinct_args_write.append(arg['name'])

#     elif arg['read'] and not arg['write']:
#         distinct_args_read.append(arg['name'])
#     elif arg['read'] and arg['write']:
#         distinct_args_read_write.append(arg['name'])


# smallest_loop = min(loops, key=lambda x: loops[x]['loop_count'])

# assert (read_args_count + write_args_count +
#         read_write_args_count == args_count)

# assert (d1_loops_count + d2_loops_count + d3_loops_count == loops_count)

print(f'Total number of functions: {functions_count}')
print(f'Total number of loops: {loops_count}')
print(f'Total number of 1D loops: {d1_loops_count}')
print(f'Total number of 2D loops: {d2_loops_count}')
print(f'Total number of 3D loops: {d3_loops_count}')
print(f'Total number of constants: {constants_count}')
print(f'Total number of locals: {locals_count}')
print(f'Total number of args: {args_count}')
print(f'Total number of read args: {read_args_count}')
print(f'Total number of write args: {write_args_count}')
print(f'Total number of read/write args: {read_write_args_count}')
# total number of loc
print(f'Total number of loc: {loc_count}')

