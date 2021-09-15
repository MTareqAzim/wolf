extends BTComposite
class_name BTSequence

var current_child : BTBehavior
var index : int = 0


func on_initialize() -> void:
	current_child = children.front()
	index = 0
	
	behavior_tree.start(current_child, passed_observer)


func update() -> int:
	return Status.SUSPENDED


func on_child_complete(passed_status : int) -> void:
	var child = current_child
	
	if child.get_status() == Status.FAILURE:
		behavior_tree.stop(self, Status.FAILURE)
		return
	
	assert(child.get_status() == Status.SUCCESS)
	
	index += 1
	if index >= children.size():
		behavior_tree.stop(self, Status.SUCCESS)
	else:
		current_child = children[index]
		behavior_tree.start(current_child, passed_observer)
