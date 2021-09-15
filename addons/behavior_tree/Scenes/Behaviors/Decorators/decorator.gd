tool
extends GraphNode

signal delete_node(node)
var connection : Node


func connect_to(node, index) -> void:
	connection = node


func disconnect_from(node, index) -> void:
	if connection == node:
		connection = null


func _on_close_request():
	clear_all_slots()
	emit_signal("delete_node", self)
	queue_free()
