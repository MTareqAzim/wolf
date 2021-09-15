tool
extends VBoxContainer

const TYPES  = ["Root", "Selector", "Sequence", "Parallel", "Monitor", "Inverter",
				"Failer", "Succeeder", "Repeater", "Action", "Condition"]

var property_scene = preload("res://addons/behavior_tree/Scenes/Property.tscn")

var selected_node : GraphNode = null

onready var type : LineEdit = $Type/LineEdit
onready var properties : VBoxContainer = $Properties


func update_info(node) -> void:
	if node == null:
		reset()
		return
	
	_clear_properties()
	type.text = TYPES[node.get_type()]
	_update_properties(node)
	selected_node = node


func reset() -> void:
	type.text = "Node Type"
	_clear_properties()
	selected_node = null


func value_entered(property, type, value) -> void:
	if selected_node == null:
		return
	
	var typed_value
	
	match type:
		TYPE_BOOL:
			typed_value = bool(value)
		TYPE_INT:
			typed_value = int(value)
		TYPE_REAL:
			typed_value = float(value)
		TYPE_STRING:
			typed_value = str(value)
	
	if selected_node.has_method("set_property"):
		selected_node.set_property(property, typed_value)
	else:
		selected_node.set(property, typed_value)


func _update_properties(node : GraphNode) -> void:
	if not node:
		return
	var property_list = node.get_property_list()
	var exported_variables = []
	
	for property in property_list:
		if property["usage"] == 8199:
			exported_variables.append(property)
	
	for variable in exported_variables:
		_add_property(variable, node.get(variable["name"]))
	
	if node.has_method("get_script_variables"):
		var script_variables = node.get_script_variables()
		for variable in script_variables:
			_add_property(variable, variable["value"])


func _add_property(variable: Dictionary, value) -> void:
	var property_node = property_scene.instance()
	properties.add_child(property_node)
	
	property_node.set_property(variable["name"], variable["type"], value)
	property_node.connect("value_entered", self, "value_entered")
	_resize()


func _clear_properties() -> void:
	for child in properties.get_children():
		if child is HBoxContainer:
			child.queue_free()


func _resize():
	properties.rect_size = properties.get_minimum_size()
	rect_size = get_minimum_size()
