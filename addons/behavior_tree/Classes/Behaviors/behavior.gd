extends Resource
class_name BTBehavior

enum Status {
	INVALID,
	SUCCESS,
	FAILURE,
	RUNNING,
	ABORTED,
	SUSPENDED
}

var behavior_tree
var status : int = Status.INVALID
var observer : BehaviorObserver


func on_initialize() -> void:
	pass


func update() -> int:
	return Status.INVALID


func on_terminate(termination_status : int) -> void:
	pass


func tick() -> int:
	if status != Status.RUNNING:
		on_initialize()
	
	status = update()
	
	if status != Status.RUNNING:
		on_terminate(status)
	
	return status


func reset() -> void:
	status = Status.INVALID


func abort() -> void:
	on_terminate(Status.ABORTED)
	status = Status.ABORTED


func is_terminated() -> bool:
	return [Status.SUCCESS, Status.FAILURE, Status.ABORTED].has(status)


func is_running() -> bool:
	return [Status.RUNNING, Status.SUSPENDED].has(status)


func get_status() -> int:
	return status
