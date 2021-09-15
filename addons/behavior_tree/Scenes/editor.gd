tool
extends Panel

var selected_node = null

onready var info = $Mount/Editor/Info/Info/Info


func _ready():
	rect_size = get_minimum_size()
	get_graph_edit().editor = self


func get_graph_edit() -> Node:
	return $"Mount/Editor/Graph/Behavior Tree"


func halt(value):
	if not value:
		$Halt.visible = false
	else:
		$Halt.visible = true
		$Halt.text = str(value)


func update_info() -> void:
	info.update_info(selected_node)


func _on_Behavior_Tree_node_selected(node):
	selected_node = node
	update_info()


func _on_Behavior_Tree_node_unselected(node):
	if selected_node == node:
		selected_node = null
	update_info()
