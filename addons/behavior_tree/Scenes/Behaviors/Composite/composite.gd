tool
extends GraphNode

signal delete_node(node)

var label_scene := preload("res://addons/behavior_tree/Scenes/Behaviors/Composite/CompositeLabel.tscn")
var slot_counter : int = 0
var color := Color("c13535")

var label_children : Dictionary
var connections : Dictionary


func _ready():
	label_children = {}
	connections = {}


func get_class() -> String:
	return "CompositeGraphNode"


func connect_to(node, index) -> void:
	if node:
		connections[index] = node


func disconnect_from(node, index) -> void:
	if node:
		if connections[index] == node:
			connections.erase(index)


func _update_slots():
	for slot in range(slot_counter):
		var slot_number = slot + 1
		set_slot(slot_number, false, 0, color, true, 0, color)
		var label = get_child(slot_number)
		var previous_id = label.get_id()
		label.set_id(slot_number)
		var label_connection = label_children[label]
		
		if label_connection:
			var graph = get_parent()
			graph._disconnection_request(label_connection[0], previous_id - 1, label_connection[1], label_connection[2])
			graph._connection_request(label_connection[0], slot, label_connection[1], label_connection[2])
	
	if is_slot_enabled_right(slot_counter + 1):
		set_slot(slot_counter + 1,false,0,color,false,0,color)


func _connection_request(from, from_port, to, to_port) -> void:
	var label = get_child(from_port + 1)
	label_children[label] = [from, to, to_port]


func _disconnection_request(from, from_port, to, to_port) -> void:
	var label = get_child(from_port + 1)
	label_children[label] = null


func _on_Add_pressed() -> void:
	var new_label = label_scene.instance()
	new_label.set_id(slot_counter + 1)
	
	add_child_below_node(get_children()[slot_counter], new_label)
	slot_counter += 1
	label_children[new_label] = null
	_update_slots()


func _delete_label(deleted_label : Label) -> void:
	get_parent()._connection_delete_request(self, deleted_label.id - 1)
	deleted_label.queue_free()
	remove_child(deleted_label)
	label_children.erase(deleted_label)
	slot_counter -= 1
	_update_slots()
	selected = false


func _on_close_request():
	clear_all_slots()
	emit_signal("delete_node", self)
	queue_free()


func _on_minimum_size_changed():
	rect_size = get_minimum_size()
