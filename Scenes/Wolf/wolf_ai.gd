extends EnemyInputHandler


var howl_cooldown : float = 0.0


func _physics_process(delta) -> void:
	if howl_cooldown > 0 :
		howl_cooldown -= delta


func is_howl_cooldown() -> bool:
	return howl_cooldown > 0


func set_howl_cooldown(duration : float) -> void:
	howl_cooldown = duration


func _on_LookDirection_x_direction_changed(new_x_direction):
	press_action("turn_around")
	release_action("turn_around")
