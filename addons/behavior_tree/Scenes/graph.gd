tool
extends GraphEdit

enum Type {Root, Selector, Sequence, Parallel, Monitor, Inverter, Failer, Succeeder, Repeater, Action, Condition}

var root := preload("res://addons/behavior_tree/Scenes/Behaviors/Root/Root.tscn")
var selector := preload("res://addons/behavior_tree/Scenes/Behaviors/Composite/Selector.tscn")
var sequence := preload("res://addons/behavior_tree/Scenes/Behaviors/Composite/Sequence.tscn")
var parallel := preload("res://addons/behavior_tree/Scenes/Behaviors/Composite/Parallel.tscn")
var monitor := preload("res://addons/behavior_tree/Scenes/Behaviors/Composite/Monitor.tscn")
var inverter := preload("res://addons/behavior_tree/Scenes/Behaviors/Decorators/Inverter.tscn")
var failer := preload("res://addons/behavior_tree/Scenes/Behaviors/Decorators/Failer.tscn")
var succeeder := preload("res://addons/behavior_tree/Scenes/Behaviors/Decorators/Succeeder.tscn")
var repeater := preload("res://addons/behavior_tree/Scenes/Behaviors/Decorators/Repeater.tscn")
var action := preload("res://addons/behavior_tree/Scenes/Behaviors/Leaves/Action.tscn")
var condition := preload("res://addons/behavior_tree/Scenes/Behaviors/Leaves/Condition.tscn")

var lastNodePosition = Vector2(0, 0)

var editor : Panel = null
var undo_redo : UndoRedo = null
var main_root : GraphNode = null
var behavior_tree = null


func _ready() -> void :
	lastNodePosition = scroll_offset + rect_size / 2 - Vector2(150, 100)


func init_scene(scene : PackedScene, location = null) -> Node:
	var node = scene.instance()
	var offset
	
	if !location:
		offset = lastNodePosition + Vector2(20, 20)
	else:
		offset = Vector2(location.x, location.y)
	
	add_child(node)
	node.set_offset(offset)
	lastNodePosition = node.get_offset()
	
	node.connect("delete_node", self, "_node_delete_request")
	if node.has_signal("update_info"):
		node.connect("update_info", self, "update_info")
	return node


func update_info() -> void:
	editor.update_info()


func get_data() -> Array:
	var array = []
	
	if main_root:
		array = main_root.get_data(array)
	
	return array


func set_behavior_tree(bt) -> void:
	behavior_tree = bt


func reload() -> void:
	clear_editor()
	if behavior_tree:
		_build_tree(behavior_tree.data)


func load_data(data) -> void:
	clear_editor()
	if data:
		_build_tree(data)


func clear_editor() -> void:
	for connection in get_connection_list():
		disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	for child in get_children():
		if child is GraphNode:
			remove_child(child)
			child.queue_free()


func _build_tree(data) -> void:
	for node in data:
		var packed_scene = null
		match node["type"]:
			Type.Root:
				packed_scene = root
			Type.Selector:
				packed_scene = selector
			Type.Sequence:
				packed_scene = sequence
			Type.Parallel:
				packed_scene = parallel
			Type.Monitor:
				packed_scene = monitor
			Type.Inverter:
				packed_scene = inverter
			Type.Failer:
				packed_scene = failer
			Type.Succeeder:
				packed_scene = succeeder
			Type.Repeater:
				packed_scene = repeater
			Type.Action:
				packed_scene = action
			Type.Condition:
				packed_scene = condition
		var graph_node = init_scene(packed_scene, node["data"]["offset"])
		graph_node.name = node["name"]
		graph_node.rect_size = node["data"]["size"]
		
		if packed_scene == root:
			main_root = graph_node
		
		if node.has("bdata"):
			for key in node["bdata"]:
				graph_node.set(key, node["bdata"][key])
		
		if node["data"].has("text"):
			graph_node.set_text(node["data"]["text"])
		
		if graph_node.get_class() == "CompositeGraphNode":
			for i in range(node["children"].size()):
				graph_node._on_Add_pressed()
	
	for node in data:
		var i = 0
		if node.has("children"):
			for child in node["children"]:
				_connection_request(node["name"], i, child, 0)
				i += 1


func _connection_delete_request(node : GraphNode, port : int) -> void:
	var node_name = node.name
	for connection in get_connection_list():
		if connection.get("from") == node_name and connection.get("from_port") == port \
				or connection.get("to") == node_name and connection.get("to_port") == port: 
			disconnect_node(connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))


func _connection_request(from, from_slot, to, to_slot) -> void:
	connect_node(from, from_slot, to, to_slot)
	
	var from_node = get_node(from)
	var to_node = get_node(to)
	if from_node.has_method("connect_to"):
		from_node.connect_to(to_node, from_slot)


func _disconnection_request(from, from_slot, to, to_slot) -> void:
	disconnect_node(from, from_slot, to, to_slot)
	
	var from_node = get_node(from)
	var to_node = get_node(to)
	if from_node.has_method("disconnect_from"):
		from_node.disconnect_from(to_node, from_slot)


func _node_delete_request(node : GraphNode):
	var node_name = node.name
	for connection in get_connection_list():
		if connection.get("from")==node_name or connection.get("to")==node_name:
			disconnect_node(connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))
			var from_node = get_node(connection.get("from"))
			var to_node = get_node(connection.get("to"))
			if from_node.has_method("disconnect_from"):
				from_node.disconnect_from(to_node, connection.get("from_port"))
	
	if main_root.name == node_name:
		main_root = null


func _on_Root_Node_item_activated(index):
	if index == 0:
		if main_root:
			return
		
		var root_node = init_scene(root)
		main_root = root_node



func _on_Composite_Nodes_item_activated(index):
	match index:
		0:
			init_scene(selector)
		1:
			init_scene(sequence)
		2:
			init_scene(parallel)
		3:
			init_scene(monitor)


func _on_Decorator_Nodes_item_activated(index):
	match index:
		0:
			init_scene(inverter)
		1:
			init_scene(failer)
		2:
			init_scene(succeeder)
		3:
			init_scene(repeater)


func _on_Leaf_Nodes_item_activated(index):
	match index:
		0:
			init_scene(action)
		1:
			init_scene(condition)


func _on_connection_request(from, from_slot, to, to_slot):
	if from == to:
		return
	
	for connection in get_connection_list():
		if connection.get("from")==from and connection.get("from_port") == from_slot:
			disconnect_node (connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))
			var from_node = get_node(from)
			var to_node = get_node(connection.get("to"))
			if from_node.has_method("disconnect_from"):
				from_node.disconnect_from(to_node, connection.get("from_port"))
		if connection.get("to")==to and connection.get("to_port") == to_slot:
			disconnect_node (connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))
			var from_node = get_node(connection.get("from"))
			var to_node = get_node(to)
			if from_node.has_method("disconnect_from"):
				from_node.disconnect_from(to_node, connection.get("from_port"))
	
	connect_node(from, from_slot, to, to_slot)
	
	var from_node = get_node(from)
	if from_node.has_method("_connection_request"):
		from_node._connection_request(from, from_slot, to, to_slot)
	
	var to_node = get_node(to)
	if from_node.has_method("connect_to"):
		from_node.connect_to(to_node, from_slot)


func _on_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	
	var from_node = get_node(from)
	if from_node.has_method("_disconnection_request"):
		from_node._disconnection_request(from, from_slot, to, to_slot)
	
	var to_node = get_node(to)
	if from_node.has_method("disconnect_from"):
		from_node.disconnect_from(to_node, from_slot)


func _on_scroll_offset_changed(ofs):
	lastNodePosition = scroll_offset + rect_size / 2 - Vector2(150, 100)


func _on_Save_Tree_pressed():
	if behavior_tree == null:
		return
	
	var data = get_data()
	
	undo_redo.create_action("Save Behavior Tree")
	undo_redo.add_do_property(behavior_tree, "data", data)
	undo_redo.add_undo_property(behavior_tree, "data", behavior_tree.data)
	undo_redo.commit_action()
