extends BTParallel
class_name BTMonitor


func _init().(Policy.RequireOne, Policy.RequireOne):
	pass


func add_condition(condition : BTBehavior) -> void:
	children.push_front(condition)


func add_action(action : BTBehavior) -> void:
	children.push_back(action)
