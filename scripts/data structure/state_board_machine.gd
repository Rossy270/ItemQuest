extends StateMachine
class_name StateBoardMachine

@export var board: GameBoard

func _ready() -> void:
	super._ready()
	
	for child in get_children():
		if child is BoardState:
			child.board = board
			if not child.get_children().is_empty():
				for c in child.get_children():
					c.board = board
