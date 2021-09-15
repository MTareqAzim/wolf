extends BTDecorator
class_name BTRepeater

var limit : int = 0
var counter : int = 0


func set_count(count : int) -> void:
	if count < 0:
		return
	
	limit = count


func on_initialize() -> void:
	counter = 0
	behavior_tree.start(child, passed_observer)


func on_child_complete(passed_state : int) -> void:
	if passed_state == Status.FAILURE:
		behavior_tree.stop(self, Status.FAILURE)
	
	counter += 1
	if counter >= limit:
		behavior_tree.stop(self, Status.SUCCESS)
	
	child.reset()
	behavior_tree.start(child, passed_observer)


func update() -> int:
	return Status.SUSPENDED

