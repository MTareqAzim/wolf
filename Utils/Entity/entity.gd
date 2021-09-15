tool
extends KinematicBody2D
class_name Entity

const GLOBAL_GROUND : int = 0

export (int) var MAX_SPEED := 1000
export (int) var GRAVITY := 980 setget set_grav, get_grav
export (int) var FRICTION := 400 setget set_friction, get_friction
export (int) var ACCELERATION := 400 setget set_acceleration, get_acceleration
export (int) var _height := 0 setget set_height, get_height
export (int) var _z_pos := 0 setget set_z_pos, get_z_pos

onready var _z_pos_node = $"Z Pos"
onready var _base = $Base

var _velocity := Vector3() setget set_velocity, get_velocity
var _target_velocity := Vector3() setget set_target_velocity, get_target_velocity


func get_class() -> String:
	return "Entity"


func _physics_process(delta):
	if not Engine.editor_hint:
		_velocity = _apply_gravity(_velocity, delta)
		_velocity = _clamp_velocity(_velocity)
		
		
		var velocity_2d := Vector2(_velocity.x, _velocity.y)
		var target_velocity_2d := Vector2(_target_velocity.x, _target_velocity.y)
		
		velocity_2d = _apply_acceleration(velocity_2d, target_velocity_2d, delta)
		
		velocity_2d = move_and_slide(velocity_2d, Vector2.ZERO)
		_move_z_pos(_velocity.z, delta)
		
		_velocity.x = velocity_2d.x
		_velocity.y = velocity_2d.y


func _apply_gravity(velocity: Vector3, delta: float) -> Vector3:
	if not is_grounded():
		velocity.z += round(GRAVITY * delta)
	
	if is_grounded() and velocity.z > 0:
		velocity.z = 0
	
	return velocity


func _clamp_velocity(velocity: Vector3) -> Vector3:
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)
	
	return velocity


func _apply_acceleration(velocity: Vector2, target_velocity: Vector2, delta) -> Vector2:
	var final_acceleration : int = 0
	
	if target_velocity == Vector2.ZERO:
		final_acceleration = FRICTION
	else:
		if velocity == Vector2.ZERO:
			final_acceleration = ACCELERATION
		elif sign(target_velocity.x) != sign(velocity.x) or sign(target_velocity.y) != sign(velocity.y):
			final_acceleration = FRICTION + ACCELERATION
		else:
			final_acceleration = ACCELERATION
	
	var final_velocity = velocity.move_toward(target_velocity, final_acceleration * delta)
	
	return final_velocity


func _move_z_pos(z_velocity: float, delta: float) -> void:
	var delta_z = z_velocity * delta
	
	var distance_to_global_ground = GLOBAL_GROUND - _z_pos
	if distance_to_global_ground < delta_z:
		delta_z = distance_to_global_ground
	
	set_z_pos(_z_pos + delta_z)


func is_grounded() -> bool:
	return _z_pos == GLOBAL_GROUND


func set_grav(new_grav: int) -> void:
	GRAVITY = new_grav


func get_grav() -> int:
	return GRAVITY


func set_friction(new_friction: int) -> void:
	FRICTION = new_friction


func get_friction() -> int:
	return FRICTION


func set_acceleration(new_acceleration: int) -> void:
	ACCELERATION = new_acceleration


func get_acceleration() -> int:
	return ACCELERATION


func set_height(new_height: int) -> void:
	_height = new_height


func get_height() -> int:
	return _height


func set_z_pos(new_z_pos: int) -> void:
	_z_pos = new_z_pos
	
	var z_pos_node_position = _z_pos_node.get_position()
	z_pos_node_position.y = _z_pos
	_z_pos_node.set_position(z_pos_node_position)


func get_z_pos() -> int:
	return _z_pos


func set_velocity(new_velocity: Vector3) -> void:
	_velocity = new_velocity


func get_velocity() -> Vector3:
	return _velocity


func set_velocity_2d(velocity_2d: Vector2) -> void:
	_velocity.x = velocity_2d.x
	_velocity.y = velocity_2d.y


func get_velocity_2d() -> Vector2:
	return Vector2(_velocity.x, _velocity.y)


func set_z_velocity(z_velocity: int) -> void:
	_velocity.z = z_velocity


func get_z_velocity() -> int:
	return int(_velocity.z)


func set_target_velocity(target_velocity: Vector3) -> void:
	_target_velocity = target_velocity


func get_target_velocity() -> Vector3:
	return _target_velocity


func set_target_velocity_2d(target_velocity_2d: Vector2) -> void:
	_target_velocity.x = target_velocity_2d.x
	_target_velocity.y = target_velocity_2d.y


func get_target_velocity_2d() -> Vector2:
	return Vector2(_target_velocity.x, _target_velocity.y)


func get_base_transform() -> Transform2D:
	return _base.get_global_transform()
