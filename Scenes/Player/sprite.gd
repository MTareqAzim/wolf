extends Sprite


func _on_LookDirection_x_direction_changed(new_x_direction):
	flip_h = new_x_direction != 1
