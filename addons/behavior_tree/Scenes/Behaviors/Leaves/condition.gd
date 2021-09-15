tool
extends GraphNode

signal delete_node(node)
signal update_info()

onready var description = $Description
onready var file_dialog = $Button/FileDialog
onready var script_name_label = $"Script Name"

var script_path = null setget set_script_path
var script_data = {}
var script_properties = []


func get_data(array : Array) -> Array:
	var information = {}
	information["name"] = name
	information["type"] = get_type()
	information["data"] = {"offset" : offset, "size" : rect_size, "text" : description.text}
	
	if script_path:
		information["bdata"] = {"script_path" : script_path, "script_data" : script_data}
	
	array.append(information)
	return array


func set_script_path(path : String) -> void:
	script_path = path
	_update_script_label()


func set_property(property : String, value) -> void:
	if script_data.has(property):
		script_data[property] = value
		for script_property in script_properties:
			if script_property["name"] == property:
				script_property["value"] = value
				break
		return
	
	set(property, value)


func _set_script_variables() -> void:
	if not script_path:
		script_data.clear()
	
	var condition_script = load(script_path)
	var instance = condition_script.new()
	
	for property in instance.get_property_list():
		if property["usage"] == 8199:
			var property_name = property["name"]
			script_data[property_name] = instance.get(property_name)


func get_script_variables() -> Array:
	if not script_path:
		return []
	
	if script_properties:
		return script_properties
	
	var condition_script = load(script_path)
	var instance = condition_script.new()
	
	var exported_variables = []
	for property in instance.get_property_list():
		if property["usage"] == 8199:
			property["value"] = script_data[property["name"]]
			exported_variables.append(property)
	
	script_properties = exported_variables
	return exported_variables


func get_type() -> int:
	return 10


func set_text(new_text : String) -> void:
	description.text = new_text


func _update_script_label() -> void:
	if not script_path:
		script_name_label.text = "No Script"
		return
	
	var parsed_path = str(script_path).split("/")
	script_name_label.text = parsed_path[parsed_path.size() - 1]


func _on_Condition_close_request():
	clear_all_slots()
	emit_signal("delete_node", self)
	queue_free()


func _on_resize_request(new_minsize):
	rect_size = new_minsize


func _on_Button_pressed():
	file_dialog.popup()


func _on_FileDialog_file_selected(path):
	set_script_path(path)
	_set_script_variables()
	script_properties.clear()
	emit_signal("update_info")
