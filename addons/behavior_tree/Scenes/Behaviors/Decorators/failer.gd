tool
extends "res://addons/behavior_tree/Scenes/Behaviors/Decorators/decorator.gd"


func get_data(array : Array) -> Array:
	var information = {}
	information["name"] = name
	information["type"] = get_type()
	information["data"] = {"offset" : offset, "size" : rect_size}
	if connection:
		information["children"] = [connection.name]
	
	array.append(information)
	if connection:
		array = connection.get_data(array)
	return array


func get_type() -> int:
	return 6
