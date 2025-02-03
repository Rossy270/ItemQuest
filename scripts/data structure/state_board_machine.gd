extends StateMachine
class_name StateBoardMachine

@export var board: GameBoard

func _ready() -> void:
	super._ready()
	
	for child in get_children():
		if child is BoardState:
			child.board = board
