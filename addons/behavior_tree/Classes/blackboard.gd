extends Reference
class_name Blackboard


var blackboard : Dictionary


func _init() -> void:
	blackboard = {}


func clear() -> void:
	blackboard.clear()


func empty() -> bool:
	return blackboard.empty()


func erase(key : String) -> bool:
	return blackboard.erase(key)


func set(key : String, value) -> void:
	blackboard[key] = value


func get(key : String):
	return blackboard.get(key)


func has(key : String) -> bool:
	return blackboard.has(key)


func has_all(keys : PoolStringArray) -> bool:
	return blackboard.has_all(keys)


func keys() -> PoolStringArray:
	return PoolStringArray(blackboard.keys())


func size() -> int:
	return blackboard.size()
