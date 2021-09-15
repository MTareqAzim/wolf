class_name BehaviorObserver

var observer : Object
var function : String


func _init(observer_object : Object, function_name : String) -> void:
	observer = observer_object
	function = function_name


func notify(status : int) -> void:
	observer.call(function, status)
