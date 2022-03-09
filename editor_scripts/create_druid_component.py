# @license MIT, Insality 2021
# @source https://github.com/Insality/druid

import os
import sys
import deftree

current_filepath = os.path.abspath(os.path.dirname(__file__))
TEMPLATE_FILE = open(current_filepath + "/component_template.lua", "r")

def to_camel_case(snake_str):
    components = snake_str.split('_')
    return ''.join(x.title() for x in components[0:])

def main():
	filename = sys.argv[1]
	print("Create Druid component from gui file", filename)
	tree = deftree.parse(filename)
	root = tree.get_root()

	output_directory = os.path.dirname(filename)
	output_filename = os.path.splitext(os.path.basename(filename))[0]

	output_full_path = os.path.join(output_directory, output_filename + ".lua")
	is_already_exists = os.path.exists(output_full_path)
	if is_already_exists:
		print("Error: The file is already exists")
		print("File:", output_full_path)
		return

	component_name = to_camel_case(output_filename)
	component_type = output_filename
	scheme_list = []
	# Gather nodes from GUI scene
	for node in root.iter_elements("nodes"):
		name = node.get_attribute("id").value
		scheme_list.append("\t" + name.upper() + " = \"" + name + "\"")

	filedata = TEMPLATE_FILE.read()
	filedata = filedata.replace("{COMPONENT_NAME}", component_name)
	filedata = filedata.replace("{COMPONENT_TYPE}", component_type)
	filedata = filedata.replace("{SCHEME_LIST}", ",\n".join(scheme_list))

	output_file = open(output_full_path, "w")
	output_file.write(filedata)
	output_file.close()
	print("Success: The file is created")
	print("File:", output_full_path)

main()
