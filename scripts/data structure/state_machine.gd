extends Node
class_name StateMachine

@export var initial_state: State

var _state: State

func _ready() -> void:
	await owner.ready
	
	_state = initial_state
	_state.enter()


func _unhandled_input(event: InputEvent) -> void:
	_state.handle_input(event)


func _process(delta: float) -> void:
	_state.update(delta)


func _physics_process(delta: float) -> void:
	_state.physics_update(delta)


func transition_to(state_name: String, dic := {}) -> void:
	if not has_node(state_name):
		return
	
	_state.exit()
	_state = get_node(state_name)
	_state.enter(dic)
