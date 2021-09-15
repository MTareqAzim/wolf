tool
extends Label

export(int) var id = 0 setget set_id, get_id;
signal delete_me(id)


func set_id(val):
	id = val;
	text = String(id)+"."


func get_id() -> int:
	return id


func _ready():
	self.connect("delete_me",get_parent(),"_delete_label")


func _on_Delete_mouse_entered():
	$Delete.visible = true;


func _on_Label_mouse_entered():
	$Delete.visible = true;


func _on_Label_mouse_exited():
	$Delete.visible = false;


func _on_Delete_pressed():
	emit_signal("delete_me",self)
