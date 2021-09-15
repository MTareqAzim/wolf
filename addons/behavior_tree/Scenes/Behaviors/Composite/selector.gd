tool
extends "res://addons/behavior_tree/Scenes/Behaviors/Composite/composite.gd"


func get_data(array : Array) -> Array:
	var information = {}
	information["name"] = name
	information["type"] = get_type()
	information["data"] = {"offset" : offset, "size" : rect_size}
	information["children"] = []
	
	var keys = connections.keys()
	keys.sort()
	for key in keys:
		information["children"].append(connections[key].name)
	
	array.append(information)
	
	for key in keys:
		array = connections[key].get_data(array)
	return array


func get_type() -> int:
	return 1
