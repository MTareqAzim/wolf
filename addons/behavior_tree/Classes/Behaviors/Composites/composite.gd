extends BTBehavior
class_name BTComposite

var children : Array

var passed_observer : BehaviorObserver = BehaviorObserver.new(self, "on_child_complete")

func _init() -> void:
	children = []


func add_child(child : BTBehavior) -> void:
	children.push_back(child)


func remove_child(child : BTBehavior) -> void:
	children.erase(child)


func clear_children() -> void:
	children.clear()


func on_child_complete(passed_status : int) -> void:
	pass
