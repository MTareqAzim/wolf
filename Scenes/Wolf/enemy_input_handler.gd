extends InputHandler
class_name EnemyInputHandler

export (NodePath) var body
export (NodePath) var state_machine
export (NodePath) var action_buffer
export (NodePath) var look_direction
export (int, 1, 2000) var frames_per_tick := 1

var target_direction = Vector2() setget set_target_direction
var actions
var frame_counter
var provoked := false
var combat_cd := 0.0

onready var _body : KinematicBody2D = get_node(body)
onready var _state_machine : StateMachine = get_node(state_machine)
onready var _action_buffer : ActionBuffer = get_node(action_buffer)
onready var _look_direction : LookDirection = get_node(look_direction)
onready var behavior_tree : BehaviorTree = $"Behavior Tree"

var blackboard : Blackboard
var tick_delta := 0.0


func _ready():
	actions = []
	frame_counter = 0
	blackboard = behavior_tree.blackboard
	randomize()


func _physics_process(delta):
	tick_delta += delta
	
	if frame_counter + 1 >= frames_per_tick:
		update_blackboard()
		behavior_tree.tick()
		tick_delta = 0.0
	
	if Input.is_action_just_pressed("ui_select"):
		provoked = not provoked
	
	if combat_cd > 0:
		combat_cd -= delta
	
	frame_counter = (frame_counter + 1) % frames_per_tick


func get_direction() -> Vector2:
	return target_direction


func is_provoked() -> bool:
	return provoked


func set_combat_cooldown(duration : float) -> void:
	combat_cd = duration


func is_combat_cooldown() -> bool:
	return combat_cd > 0


func is_looking_at(global_point : Vector2) -> bool:
	var current_look_direction = Vector2(_look_direction.get_x_look_direction(), 0)
	var direction_to_point = _body.global_position.direction_to(global_point)
	var angle_to = current_look_direction.dot(direction_to_point)
	var acceptable_range = cos(deg2rad(30))
	
	return angle_to >= acceptable_range


func is_action_pressed(action: String) -> bool:
	return actions.has(action)


func press_action(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	
	if not actions.has(action):
		actions.append(action)
	
	_state_machine.handle_input(event)
	_action_buffer.add_action(action + "_pressed")


func release_action(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = false
	
	actions.erase(action)
	
	_state_machine.handle_input(event)
	_action_buffer.add_action(action + "_released")


func set_target_direction(direction: Vector2) -> void:
	target_direction = direction


func find_waypoint() -> void:
	var max_waypoint_distance = 700
	var min_waypoint_distance = 200
	var waypoint_direction = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()
	var waypoint_distance = randf() * (max_waypoint_distance - min_waypoint_distance) + min_waypoint_distance
	
	var waypoint = _body.position + waypoint_direction * waypoint_distance
	waypoint = Vector2(round(waypoint.x), round(waypoint.y))
	
	blackboard.set("waypoint", waypoint)
	


func update_blackboard() -> void:
	var position = _body.global_position
	var z_pos = _body.get_z_pos()
	var current_state = _state_machine.get_current_state_name()
	
	blackboard.set("position", position)
	blackboard.set("z_pos", z_pos)
	blackboard.set("current_state", current_state)
	blackboard.set("delta", tick_delta)
	
	var players = get_tree().get_nodes_in_group("player")
	if players:
		var left_of_player = players[0].global_position - Vector2(120, 0)
		var right_of_player = players[0].global_position + Vector2(120, 0)
		var target_position = right_of_player \
				if position.distance_squared_to(right_of_player) < \
				position.distance_squared_to(left_of_player) else left_of_player
		blackboard.set("target", target_position)
		blackboard.set("target_actual_position", players[0].global_position)
	else:
		blackboard.erase("target")
		blackboard.erase("target_actual_position")
