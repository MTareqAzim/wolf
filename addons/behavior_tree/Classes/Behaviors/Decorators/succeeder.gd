extends BTDecorator
class_name BTSucceeder


func on_initialize() -> void:
	behavior_tree.start(child, passed_observer)


func on_child_complete(passed_status : int) -> void:
	var return_state = passed_status
	
	if passed_status == Status.FAILURE:
		return_state = Status.SUCCESS
	
	behavior_tree.stop(self, return_state)


func update() -> int:
	return Status.SUSPENDED

