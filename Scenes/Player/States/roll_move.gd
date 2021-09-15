extends NotEqualsTransitionStateComponent

var DURATION := 0.7

onready var _timer := $Timer

func enter() -> void:
	_timer.wait_time = DURATION
	_timer.one_shot = true
	_timer.start()
	active = false


func _on_Timer_timeout():
	active = true
