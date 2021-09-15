extends ColorRect

export (NodePath) var body_node

onready var mat : = get_material()
onready var body : KinematicBody2D = get_node(body_node)
onready var animation : AnimationPlayer = $Shockwave

var current_camera : Camera2D
var camera_width : float
var camera_height : float
var x_dir : int = 1


func _ready():
	for camera in get_tree().get_nodes_in_group("cameras"):
		if camera.is_current():
			current_camera = camera
	
	camera_width = ProjectSettings.get_setting("display/window/size/width")
	camera_height = ProjectSettings.get_setting("display/window/size/height")


func _process(delta):
	var camera_global_position := Vector2()
	if current_camera:
		camera_global_position = current_camera.global_position - Vector2(camera_width/2, camera_height/2)
	var position_to_camera : Vector2 = body.global_position - camera_global_position + (Vector2(62, 0) * x_dir)
	var scaled_postion = Vector2(position_to_camera.x/camera_width, -position_to_camera.y/camera_height + 1.0)
	var center = scaled_postion
	mat.set_shader_param("center", center)


func play_shockwave() -> void:
	animation.play("shockwave")


func _on_LookDirection_x_direction_changed(new_x_direction):
	x_dir = new_x_direction
