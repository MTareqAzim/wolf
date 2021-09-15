tool
extends Node
class_name BehaviorTree

enum Status {
	INVALID,
	SUCCESS,
	FAILURE,
	RUNNING,
	ABORTED,
	SUSPENDED
}

export (NodePath) var actor_node
export (Array) var data
export (bool) var active := true

var root
var behaviors : Array
var blackboard

onready var actor = get_node(actor_node)


func _init():
	behaviors = []
	blackboard = Blackboard.new()


func _ready() -> void:
	root = BehaviorTreeGenerator.generate_tree(data)
	if not root:
		return
	if active:
		start(root)


func get_class() -> String:
	return "BehaviorTree"


func start(behavior, observer : BehaviorObserver = null) -> void:
	if observer != null:
		behavior.observer = observer
	
	behavior.set("behavior_tree", self)
	behavior.set("blackboard", blackboard)
	behavior.set("actor", actor)
	
	behaviors.push_front(behavior)


func stop(behavior, result : int) -> void:
	assert(result != Status.RUNNING and result != Status.SUSPENDED)
	behavior.status = result
	
	if behavior.observer:
		behavior.observer.notify(result)


func tick() -> void:
	behaviors.push_back(null)
	
	while step():
		continue


func step() -> bool:
	var current_behavior = behaviors.front()
	behaviors.pop_front()
	
	if current_behavior == null:
		return false
	
	current_behavior.tick()
	
	if current_behavior.is_terminated() and current_behavior.observer:
		current_behavior.observer.notify(current_behavior.get_status())
	elif current_behavior.get_status() == Status.SUSPENDED and current_behavior.observer:
		pass
	else:
		behaviors.push_back(current_behavior)
	
	return true
