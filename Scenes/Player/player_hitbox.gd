extends "res://Utils/Entity/Hitbox/hitbox.gd"

export (float, 0, 2147483647) var damage setget set_damage, get_damage
export (int) var delay_mseconds := 15


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


func _on_area_entered(area):
	if is_overlapping(area):
		OS.delay_msec(delay_mseconds)
