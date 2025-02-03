extends Node
class_name State

@onready var _state_machine: StateMachine = _get_state_machine(self)


func _get_state_machine(node: Node) -> StateMachine:
	if node != null and node is not StateMachine:
		return _get_state_machine(node.get_parent())
	return node


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
