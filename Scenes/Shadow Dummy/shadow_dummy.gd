extends Entity


onready var health : Health = $Health

func _process(delta):
	if health.get_health() != health.get_max_health():
		health.heal_health(30.0 * delta)


func _on_Health_died():
	queue_free()
