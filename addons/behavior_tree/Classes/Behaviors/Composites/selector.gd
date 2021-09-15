extends BTComposite
class_name BTSelector

var current_child : BTBehavior
var index : int = 0

func _init().() -> void:
	pass


func on_initialize() -> void:
	current_child = children.front()
	index = 0
	
	behavior_tree.start(current_child, passed_observer)


func update() -> int:
	return Status.SUSPENDED


func on_child_complete(passed_status : int) -> void:
	var child = current_child
	
	if child.get_status() == Status.SUCCESS:
		behavior_tree.stop(self, Status.SUCCESS)
		return
	
	assert(child.get_status() == Status.FAILURE)
	
	index += 1
	if index >= children.size():
		behavior_tree.stop(self, Status.FAILURE)
	else:
		current_child = children[index]
		behavior_tree.start(current_child, passed_observer)
