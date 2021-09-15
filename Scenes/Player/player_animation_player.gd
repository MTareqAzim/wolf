extends AnimationPlayer

export (String) var state := "idle"
export (String) var look_direction := "right"


func _ready():
	play_proper_animation()


func play_proper_animation():
	var new_animation = look_direction + "_" + state
	play(new_animation)


func _on_StateMachine_state_changed(current_state):
	state = current_state
	
	play_proper_animation()


func _on_LookDirection_x_direction_changed(new_x_direction):
	look_direction = "right" if new_x_direction == 1 else "left"
	
	play_proper_animation()
