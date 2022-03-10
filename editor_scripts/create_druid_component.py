# @license MIT, Insality 2021
# @source https://github.com/Insality/druid

import os
import sys
import deftree

current_filepath = os.path.abspath(os.path.dirname(__file__))
TEMPLATE_FILE = open(current_filepath + "/component_template.lua", "r")

component_annotations = ""
component_functions = ""
component_define = ""

def to_camel_case(snake_str):
	components = snake_str.split('_')
	return ''.join(x.title() for x in components[0:])


def get_id(node_name):
	return node_name.upper().replace("/", "_")


def process_component(node_name, component_name):
	global component_annotations
	global component_functions
	global component_define

	if node_name.startswith("button"):
		component_annotations += "\n---@field {0} druid.button".format(node_name)
		component_functions += "\nfunction {1}:_on_{0}()\n\tprint(\"Click on {0}\")\nend\n\n".format(node_name, component_name)
		component_define += "\n\tself.{0} = self.druid:new_button(SCHEME.{1}, self._on_{0})".format(node_name, get_id(node_name))

	if node_name.startswith("text"):
		component_annotations += "\n---@field {0} druid.text".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_text(SCHEME.{1})".format(node_name, get_id(node_name))

	if node_name.startswith("lang_text"):
		component_annotations += "\n---@field {0} druid.text".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_lang_text(SCHEME.{1}, \"lang_id\")".format(node_name, get_id(node_name))

	if node_name.startswith("grid") or node_name.startswith("static_grid"):
		component_annotations += "\n---@field {0} druid.static_grid".format(node_name)
		component_define += "\n--TODO: Replace prefab_name with grid element prefab"
		component_define += "\n\tself.{0} = self.druid:new_static_grid(SCHEME.{1}, \"prefab_name\", 1)".format(node_name, get_id(node_name))

	if node_name.startswith("dynamic_grid"):
		component_annotations += "\n---@field {0} druid.dynamic_grid".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_dynamic_grid(SCHEME.{1})".format(node_name, get_id(node_name))

	if node_name.startswith("scroll_view"):
		field_name = node_name.replace("_view", "")
		content_name = node_name.replace("_view", "_content")
		component_annotations += "\n---@field {0} druid.scroll".format(field_name)
		component_define += "\n\tself.{0} = self.druid:new_scroll(SCHEME.{1}, SCHEME.{2})".format(field_name, get_id(node_name), get_id(content_name))

	if node_name.startswith("blocker"):
		component_annotations += "\n---@field {0} druid.blocker".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_blocker(SCHEME.{1})".format(node_name, get_id(node_name))

	if node_name.startswith("slider"):
		component_annotations += "\n---@field {0} druid.slider".format(node_name)
		component_define += "\n--TODO: Replace slider end position. It should be only vertical or horizontal"
		component_define += "\n\tself.{0} = self.druid:new_slider(SCHEME.{1}, vmath.vector3(100, 0, 0), self._on_{0}_change)".format(node_name, get_id(node_name))
		component_functions += "\nfunction {1}:_on_{0}_change(value)\n\tprint(\"Slider change:\", value)\nend\n\n".format(node_name, component_name)

	if node_name.startswith("progress"):
		component_annotations += "\n---@field {0} druid.progress".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_progress(SCHEME.{1}, \"x\")".format(node_name, get_id(node_name))

	if node_name.startswith("timer"):
		component_annotations += "\n---@field {0} druid.timer".format(node_name)
		component_define += "\n\tself.{0} = self.druid:new_timer(SCHEME.{1}, 59, 0, self._on_{0}_end)".format(node_name, get_id(node_name))
		component_functions += "\nfunction {1}:_on_{0}_end()\n\tprint(\"Timer {0} trigger\")\nend\n\n".format(node_name, component_name)


def main():
	global component_annotations
	global component_functions
	global component_define

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

	component_require_path = os.path.join(output_directory, output_filename).replace("/", ".").replace("..", "")
	component_name = to_camel_case(output_filename)
	component_type = output_filename
	scheme_list = []

	# Gather nodes from GUI scene
	for node in root.iter_elements("nodes"):
		node_name = node.get_attribute("id").value
		scheme_list.append("\t" + get_id(node_name) + " = \"" + node_name + "\"")

		is_template = node.get_attribute("template")
		is_in_template = "/" in node_name
		if not is_template and not is_in_template:
			process_component(node_name, component_name)

	if len(component_define) > 2:
		component_define = "\n" + component_define

	filedata = TEMPLATE_FILE.read()
	filedata = filedata.replace("{COMPONENT_NAME}", component_name)
	filedata = filedata.replace("{COMPONENT_TYPE}", component_type)
	filedata = filedata.replace("{COMPONENT_PATH}", component_require_path)
	filedata = filedata.replace("{COMPONENT_DEFINE}", component_define)
	filedata = filedata.replace("{COMPONENT_FUNCTIONS}", component_functions)
	filedata = filedata.replace("{COMPONENT_ANNOTATIONS}", component_annotations)
	filedata = filedata.replace("{SCHEME_LIST}", ",\n".join(scheme_list))

	output_file = open(output_full_path, "w")
	output_file.write(filedata)
	output_file.close()
	print("Success: The file is created")
	print("File:", output_full_path)

main()
