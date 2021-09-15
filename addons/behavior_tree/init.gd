tool
extends EditorPlugin

var dock_scene := load("res://addons/behavior_tree/Scenes/Editor.tscn")
var dock


func selection_changed():
	if not dock:
		return
	
	var graph_edit = dock.get_graph_edit()
	graph_edit.set_behavior_tree(null)
	graph_edit.clear_editor()
	
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	if not selection:
		dock.halt("Please select a Behavior Tree node.")
		return
	
	if selection.size() == 1:
		if selection[0].get_class() == "BehaviorTree":
			graph_edit.set_behavior_tree(selection[0])
			graph_edit.load_data(selection[0].data)
			dock.halt(null)
		else:
			dock.halt("Please select a Behavior Tree node.")
	else:
		dock.halt("Please select a Behavior Tree node.")


func make_visible(visible):
	if not dock:
		return
	if visible:
		var graph_edit = dock.get_graph_edit()
		graph_edit.reload()
		dock.show()
	else:
		var graph_edit = dock.get_graph_edit()
		graph_edit._on_Save_Tree_pressed()
		graph_edit.clear_editor()
		dock.hide()


func has_main_screen():
	return true


func get_plugin_name():
	return "Behavior Tree"


func _enter_tree():
	add_custom_type("Behavior Tree", "Node", 
		load("res://addons/behavior_tree/Classes/behavior_tree.gd"), 
		load("res://addons/behavior_tree/Classes/behavior_tree.png"))
	
	dock = dock_scene.instance()
	dock.halt("Please select a Behavior Tree node.")
	get_editor_interface().get_editor_viewport().add_child(dock)
	get_editor_interface().get_selection().connect("selection_changed",self,"selection_changed");
	
	var graph_edit = dock.get_graph_edit()
	graph_edit.undo_redo = get_undo_redo()
	
	make_visible(false)


func _exit_tree():
	remove_custom_type("Behavior Tree")
	dock.queue_free()
	dock = null
