extends AnimationPlayer


export (String) var state := "idle"


func _ready():
	play_proper_animation()


func play_proper_animation() -> void:
	stop()
	play(state)


func _on_StateMachine_state_changed(current_state):
	state = current_state
	play_proper_animation()
