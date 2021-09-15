extends Control


export (NodePath) var health
export (NodePath) var stamina


onready var _health : Health = get_node(health)
onready var health_bar = $HealthBar
onready var _stamina : Stamina = get_node(stamina)
onready var stamina_bar = $StaminaBar


func _ready():
	update_health_bar(_health.get_health())
	update_stamina_bar(_stamina.get_stamina())


func update_health_bar(current_health) -> void:
	var max_health = _health.get_max_health()
	var percent = 100.0 * float(current_health) / max_health
	health_bar.set_percent(percent)


func update_stamina_bar(current_stamina) -> void:
	var max_stamina = _stamina.get_max_stamina()
	var percent = 100.0 * current_stamina / max_stamina
	stamina_bar.set_percent(percent)


func health_bar_flash(color : Color) -> void:
	health_bar.flash(color)


func stamina_bar_flash(color : Color) -> void:
	stamina_bar.flash(color)


func _on_Health_health_changed(new_health):
	update_health_bar(new_health)


func _on_Stamina_stamina_changed(new_stamina):
	update_stamina_bar(new_stamina)


func _on_Health_max_health_changed(new_max_health):
	update_health_bar(_health.get_health())


func _on_Stamina_max_stamina_changed(new_max_stamina):
	update_stamina_bar(_stamina.get_stamina())
