extends Area2D

export (NodePath) var body_node
export (int, 0, 2147483647) var extent := 0 setget set_extent, get_extent


onready var body = get_node(body_node)


func get_floor_y() -> float:
	return body.global_position.y


func set_extent(new_extent : int) -> void:
	extent = new_extent


func get_extent() -> int:
	return extent


func is_overlapping(area: Area2D) -> bool:
	if not area.has_method("get_floor_y") or \
		not area.has_method("get_extent"):
			return false
	
	var floor_y = get_floor_y()
	var other_y = area.get_floor_y()
	var other_extent = area.get_extent()
	
	if (floor_y <= other_y + other_extent and floor_y >= other_y - other_extent) or \
		(other_y <= floor_y + extent and other_y >= floor_y - extent):
		return true
	
	return false
