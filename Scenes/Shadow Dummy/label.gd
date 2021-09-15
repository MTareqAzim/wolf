extends Label



func _on_Health_health_changed(health):
	text = str(round(health))
