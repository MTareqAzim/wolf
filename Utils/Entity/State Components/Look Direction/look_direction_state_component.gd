extends EntityStateComponent
class_name LookDirectionStateComponent, "look_direction.png"

export (String) var look_direction_key := "look"
export (String) var input_handler_key := "input"

var _look_direction : LookDirection
var _input_handler : InputHandler

func update(delta: float) -> void:
	var look_direction = _input_handler.get_direction()
	
	#var x_direction = sign(look_direction.x) if abs(look_direction.x) > 0.1 else 0
	#var y_direction = sign(look_direction.y) if abs(look_direction.y) > 0.1 else 0
	
	_update_look_direction(look_direction)


func assign_dependencies() -> void:
	_look_direction = component_state.get_dependency(look_direction_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func _update_look_direction(direction: Vector2) -> void:
	if _look_direction.get_look_direction() == direction:
		return
	
	_look_direction.set_look_direction(direction)
