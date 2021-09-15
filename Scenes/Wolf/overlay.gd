extends TextureRect


export (NodePath) var camera_node

onready var camera : Camera2D = get_node(camera_node)


func _process(delta):
	var img = camera.get_viewport().get_texture().get_data()
	img.flip_y()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	texture = tex
