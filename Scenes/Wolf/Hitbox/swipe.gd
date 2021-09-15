extends "res://Utils/Entity/Hitbox/hitbox.gd"


export (int) var offset := 0
export (float, 0, 2147483647) var damage setget set_damage, get_damage


func get_floor_y() -> float:
	return body.global_position.y + offset


func set_damage(new_damage : float) -> void:
	if new_damage >= 0:
		damage = new_damage


func get_damage() -> float:
	return damage


func _on_LookDirection_x_direction_changed(new_x_direction):
	if new_x_direction == 1:
		scale.x = 1
	elif new_x_direction == -1:
		scale.x = -1
