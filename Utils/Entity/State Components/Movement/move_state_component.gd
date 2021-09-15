extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (String) var body_key := "body"
export (String) var input_handler_key := "input"
export (String) var max_speed_key := "max_speed"

var _body
var _input_handler : InputHandler
var _max_speed : int = 0


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	_move_2d(input_direction, _max_speed)


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func assign_variables() -> void:
	_max_speed = component_state.get_variable(max_speed_key)


func _move_2d(direction: Vector2, speed: int) -> void:
	var normalized_direction = direction.normalized()
	
	var velocity_2d = Vector2(normalized_direction.x * speed, normalized_direction.y * speed / 2)
	
	_body.set_target_velocity_2d(velocity_2d)
