tool
extends HBoxContainer

signal value_entered(property, type, value)

var property = ""
var type : int = 0

onready var name_label = $Name
onready var line_edit = $LineEdit


func set_property(new_property, new_type, value) -> void:
	property = str(new_property)
	var displayed_text = str(new_property) + ":"
	name_label.text = displayed_text
	name_label.hint_tooltip = displayed_text
	line_edit.text = String(value)
	type = new_type


func _on_LineEdit_text_entered(new_text):
	emit_signal("value_entered", property, type, new_text)
	line_edit.release_focus()
