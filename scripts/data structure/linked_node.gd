extends RefCounted
class_name LinkedNode

var value: Vector2i
var priority: int
var next: LinkedNode

func _init(node_value: Vector2i, node_priority: int, nex_node: LinkedNode = null) -> void:
	value = node_value
	priority = node_priority
	next = nex_node
