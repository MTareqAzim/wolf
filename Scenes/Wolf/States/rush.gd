extends EntityStateComponent

export (String) var input_handler_key := "input"
export (String) var look_direciton_key := "look"
export (String) var body_key := "body"
export (String) var max_distance_key := "max_distance"
export (String) var duration_key := "duration"

onready var _timer : Timer = $Timer
var _input : InputHandler
var _look : LookDirection
var _body : Entity
var _max_distance : int = 0
var _direction := Vector2()
var _speed : int = 0
var _duration : float = 0.0

func enter() -> void:
	_direction = _input.get_direction()
	if _direction == Vector2.ZERO:
		_direction = _look.get_look_direction()
	
	_look.set_look_direction(_direction)
	
	_timer.wait_time = _duration
	_timer.one_shot = true
	_timer.start()
	
	_speed = round(_max_distance / _duration)
	_move_2d(_direction, _speed)


func assign_dependencies() -> void:
	_input = component_state.get_dependency(input_handler_key)
	_look = component_state.get_dependency(look_direciton_key)
	_body = component_state.get_dependency(body_key)


func assign_variables() -> void:
	_max_distance = component_state.get_variable(max_distance_key)
	_duration = component_state.get_variable(duration_key)


func _move_2d(direction: Vector2, speed: int) -> void:
	var normalized_direction = direction.normalized()
	
	var velocity_2d = Vector2(normalized_direction.x * speed, normalized_direction.y * speed / 2)
	
	_body.set_velocity_2d(velocity_2d)
	_body.set_target_velocity_2d(velocity_2d)


func _on_Timer_timeout():
	_body.set_target_velocity_2d(Vector2())
	_body.set_velocity_2d(_body.get_velocity_2d()/3)
