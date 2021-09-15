extends PlayerInputHandler




func _on_LookDirection_x_direction_changed(new_x_direction):
	var turn_around_event = InputEventAction.new()
	turn_around_event.action = "turn_around"
	turn_around_event.pressed = true
	
	_state_machine.handle_input(turn_around_event)
