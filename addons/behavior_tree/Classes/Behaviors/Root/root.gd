extends BTBehavior
class_name BTRoot

var child : BTBehavior setget add_child
var passed_observer : BehaviorObserver = BehaviorObserver.new(self, "on_child_complete")


func add_child(child_behavior) -> void:
	child = child_behavior


func on_child_complete(passed_status : int) -> void:
	behavior_tree.stop(self, passed_status)


func on_initialize() -> void:
	behavior_tree.start(child, passed_observer)


func update() -> int:
	return Status.RUNNING
