extends BTBehavior
class_name BTDecorator

var child : BTBehavior setget add_child
var passed_observer : BehaviorObserver = BehaviorObserver.new(self, "on_child_complete")


func add_child(child_behavior : BTBehavior) -> void:
	child = child_behavior


func on_child_complete(passed_status : int) -> void:
	pass
