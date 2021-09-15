extends "res://Utils/Entity/Hurtbox/hurtbox.gd"

export (NodePath) var health_node
export (NodePath) var animation_player_node

onready var health : Health = get_node(health_node)
onready var animation_player : AnimationPlayer = get_node(animation_player_node)


func damage_health(damage) -> void:
	health.damage_health(damage)
	animation_player.play("flash")


func _on_area_entered(area) -> void:
	if is_overlapping(area):
		if area.has_method("get_damage"):
			var damage = area.get_damage()
			damage_health(damage)
