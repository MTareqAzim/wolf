extends TextureRect

const MAX_X_SIZE = 200
const MIN_X_SIZE = 3
const Y_SIZE = 4

export (float, 0.0, 100.0) var percent := 100.0 setget set_percent

onready var _bar : NinePatchRect = $Bar
onready var _animation_player : AnimationPlayer = $AnimationPlayer
onready var _overlay : ColorRect = $Overlay


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
	
	_bar.self_modulate = Color(1, 0, 0, 1) if percent <= 25.0 else Color.white


func flash(flash_color : Color) -> void:
	_overlay.color = flash_color
	_animation_player.play("flash")
