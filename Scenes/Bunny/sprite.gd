extends Sprite	


func _on_LookDirection_x_direction_changed(new_x_direction):
	flip_h = true if new_x_direction == 1 else false
