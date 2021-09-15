extends InputHandler

export (NodePath) var patrol_points_node

var direction := Vector2()
var target_position := Vector2()
var counter: int = 0
var patrol_points : Array

onready var body := get_parent()
onready var spawn_position : Vector2 = body.position
onready var patrol_points_polygon := get_node(patrol_points_node)


func _ready():
	patrol_points = patrol_points_polygon.polygon
	target_position = patrol_points[counter] + spawn_position + patrol_points_polygon.position


func _physics_process(delta):
	patrol()


func patrol() -> void:
	if body.position.distance_to(target_position) < 5:
		counter = (counter + 1) % patrol_points.size()
		target_position = patrol_points[counter] + spawn_position + patrol_points_polygon.position
	
	var target_direction : Vector2 = (target_position - body.position).normalized()
	target_direction.y = target_direction.y * 2
	target_direction = target_direction.normalized()
	
	direction = target_direction


func get_direction() -> Vector2:
	return direction
