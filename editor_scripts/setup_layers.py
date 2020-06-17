# @license MIT, Insality 2020
# @source https://github.com/Insality/druid

import sys
import deftree

def main():
	filename = sys.argv[1]
	print("Auto setup layers for file", filename)
	tree = deftree.parse(filename)
	root = tree.get_root()

	layers = []
	for texture in root.iter_elements("textures"):
		layers.append(texture.get_attribute("name").value)

	for fonts in root.iter_elements("fonts"):
		layers.append(fonts.get_attribute("name").value)

	to_remove_layers = []
	for layer in root.iter_elements("layers"):
		to_remove_layers.append(layer)
	for layer in to_remove_layers:
		root.remove(layer)

	for layer in layers:
		new_layer = root.add_element("layers")
		new_layer.add_attribute("name", layer)

	for node in root.iter_elements("nodes"):
		texture = node.get_attribute("texture")
		font = node.get_attribute("font")

		if texture:
			layer = texture.value.split("/")[0]
			node.set_attribute("layer", layer)

		if font:
			layer = font.value
			node.set_attribute("layer", layer)

	tree.write()

main()