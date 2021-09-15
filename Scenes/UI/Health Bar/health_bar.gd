extends TextureRect

const MAX_X_SIZE = 212
const MIN_X_SIZE = 3
const Y_SIZE = 6

export (float, 0.0, 100.0) var percent := 100.0 setget set_percent

onready var _bar : NinePatchRect = $Bar
onready var _animation_player : AnimationPlayer = $AnimationPlayer
onready var _overlay = $Overlay


func _ready() -> void:
	resize_bar()


func set_percent(new_percent: float) -> void:
	if new_percent < 0:
		new_percent = 0.0
	
	if new_percent > 100:
		new_percent = 100.0
	
	percent = new_percent
	call_deferred("resize_bar")


func resize_bar() -> void:
	if round(percent) == 0:
		_bar.visible = false
		return
	
	var bar_x_size = round(((MAX_X_SIZE - MIN_X_SIZE) / 100.0 * percent) + MIN_X_SIZE)
	_bar.rect_size = Vector2(bar_x_size, Y_SIZE)
	_bar.visible = true


func flash(flash_color : Color) -> void:
	_overlay.color = flash_color
	_animation_player.play("flash")
