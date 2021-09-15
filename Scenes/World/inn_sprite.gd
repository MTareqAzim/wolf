extends Sprite


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		self_modulate = Color(1, 1, 1, 0.5)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		self_modulate = Color(1, 1, 1, 1)
