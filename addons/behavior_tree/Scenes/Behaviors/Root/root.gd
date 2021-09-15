tool
extends GraphNode

signal delete_node(node)
var connection : Node


func connect_to(node, index) -> void:
	connection = node


func disconnect_from(node, index) -> void:
	if connection == node:
		connection = null


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
	return 0


func _on_close_request():
	clear_all_slots()
	emit_signal("delete_node", self)
	queue_free()
