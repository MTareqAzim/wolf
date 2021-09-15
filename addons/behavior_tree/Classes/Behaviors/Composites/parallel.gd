extends BTComposite
class_name BTParallel

enum Policy {
	RequireOne,
	RequireAll
}

var success_policy : int
var failure_policy : int

var success_count : int = 0
var failure_count : int = 0


func _init(policy_for_success : int, policy_for_failure : int).() -> void:
	success_policy = policy_for_success
	failure_policy = policy_for_failure


func on_initialize() -> void:
	success_count = 0
	failure_count = 0
	
	for child in children:
		behavior_tree.start(child, passed_observer)


func on_child_complete(passed_status : int) -> void:
	if passed_status == Status.SUCCESS:
		success_count += 1
		if success_policy == Policy.RequireOne:
			behavior_tree.stop(self, Status.SUCCESS)
	
	if passed_status == Status.FAILURE:
		failure_count += 1
		if failure_policy == Policy.RequireOne:
			behavior_tree.stop(self, Status.FAILURE)
	
	if failure_policy == Policy.RequireAll and failure_count == children.size():
		behavior_tree.stop(self, Status.FAILURE)
	
	if success_policy == Policy.RequireAll and success_count == children.size():
		behavior_tree.stop(self, Status.SUCCESS)


func update() -> int:
	return Status.SUSPENDED


func on_terminate(termination_status : int) -> void:
	for child in children:
		if child.is_running():
			child.abort()
