extends Node
class_name StateMachine, "state_machine.png"

signal state_changed(current_state)
signal states_stack_changed(states_stack)

export (bool) var _active := false setget set_active


var current_state : State = null

var _start_state : Node = null
var _states_map : Dictionary = {}
var _states_stack : Array = []
var _push_down_states : Array = []
var _overwrite_states : Array = []


func _ready() -> void:
	_append_states(self)
	_attach_finished_signals()
	initialize()


func _physics_process(delta: float) -> void:
	current_state.update(delta)


func on_animation_finished(animation: String) -> void:
	current_state.on_animation_finished(animation)


func get_class() -> String:
	return "StateMachine"


func is_class(type: String) -> bool:
	return type == "StateMachine" or .is_class(type)


func initialize() -> void:
	set_active(true)
	_states_stack.push_front(_start_state)
	current_state = _states_stack[0]
	current_state.enter()


func set_active(active: bool) -> void:
	_active = active
	set_physics_process(active)
	set_process_input(active)
	if not _active:
		_states_stack = []
		current_state = null


func get_current_state() -> State:
	return current_state


func get_current_state_name() -> String:
	return current_state.state_name


func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _append_states(node: Node) -> void:
	for i in node.get_child_count():
		var child = node.get_child(i)
		if child is State:
			if not _start_state:
				_start_state = child
			_states_map[child.state_name] = child
			if child.push_down:
				_push_down_states.append(child.state_name)
			if child.overwrite:
				_overwrite_states.append(child.state_name)
		
		if child.get_child_count() > 0:
			_append_states(child)


func _attach_finished_signals() -> void:
	for state in _states_map.values():
		state.connect("finished", self, "_change_state")


func _change_state(requestor: String, state_name: String) -> void:
	if not _active:
		return
	
	if current_state.state_name != requestor:
		return
	
	if state_name != "previous":
		if not _states_map.has(state_name):
			return
	
	if state_name in _overwrite_states:
		if _states_stack.size() > 1:
			_states_stack.pop_front()
	
	if state_name in _push_down_states:
		_states_stack.push_front(_states_map[state_name])
	
	current_state.exit()
	
	if state_name == "previous":
		_states_stack.pop_front()
	else:
		_states_stack[0] = _states_map[state_name]
	
	current_state = _states_stack[0]
	emit_signal("state_changed", current_state.state_name)
	emit_signal("states_stack_changed", _states_stack)
	
	if state_name != "previous":
		current_state.enter()
	else:
		current_state.resume()
