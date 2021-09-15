extends State
class_name ComponentState, "state.png"

export (Dictionary) var dependencies := {}
export (Dictionary) var variables := {}

var _components : Array = []
var _dependencies : Dictionary = {}


func _ready() -> void:
	_append_components(self)
	_append_dependencies()
	_assign_dependencies()
	_assign_variables()


func get_class() -> String:
	return "ComponentState"


func is_class(type: String) -> bool:
	return type == "ComponentState" or .is_class(type)


func enter() -> void:
	_call_component_function("enter")


func resume() -> void:
	_call_component_function("resume")


func exit() -> void:
	_call_component_function("exit")


func handle_input(event: InputEvent) -> void:
	_call_component_function("handle_input", [event])


func update(delta: float) -> void:
	_call_component_function("update", [delta])


func on_animation_finished(animation: String) -> void:
	_call_component_function("on_animation_finished", [animation])


func finished(next_state: String) -> void:
	emit_signal("finished", state_name, next_state)


func get_dependency(key: String) -> Node:
	return _dependencies[key]


func get_variable(key: String):
	return variables[key]


func _append_components(node: Node) -> void:
	for i in node.get_child_count():
		var child = node.get_child(i)
		if child is StateComponent:
			_components.append(child)
			child.component_state = self
		
		if child.get_child_count() > 0:
			if not child.get_class() == "ComponentState":
				_append_components(child)


func _append_dependencies() -> void:
	_dependencies.clear()
	for key in dependencies:
		_dependencies[key] = get_node(dependencies[key])


func _assign_dependencies() -> void:
	_call_component_function_always("assign_dependencies")


func _assign_variables() -> void:
	_call_component_function_always("assign_variables")


func _call_component_function(function: String, args: Array = []) -> void:
	for component in _components:
		if component.active and component.has_method(function):
			component.callv(function, args)


func _call_component_function_always(function: String, args: Array = []) -> void:
	for component in _components:
		if component.has_method(function):
			component.callv(function, args)
