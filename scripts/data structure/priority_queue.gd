extends RefCounted
class_name PriorityQueue

var front: LinkedNode

func _init() -> void:
	front = null


func is_empty() -> bool:
	return front == null


func push(value: Vector2i, priority: int) -> void:
	if is_empty() or front.priority > priority:
		front = LinkedNode.new(value, priority, front)
	else:
		var temp = front
		while temp.next and temp.next.priority <= priority:
			temp = temp.next
		temp.next = LinkedNode.new(value, priority, temp.next)


func pop() -> LinkedNode:
	if is_empty():
		return null
	var temp = front
	front = front.next
	return temp
