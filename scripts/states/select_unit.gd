extends BoardState

var unit: Unit

func enter(_msg := {}) -> void:
	board.cursor.accept_pressed.connect(_on_Cursor_accept_pressed)
	board.cursor.moved.connect(_on_Cursor_move)


func exit() -> void:
	board.cursor.accept_pressed.disconnect(_on_Cursor_accept_pressed)
	board.cursor.moved.disconnect(_on_Cursor_move)
	
	if unit and unit.is_hover:
		board.select_unit(unit.cell)
		unit = null


func _on_Cursor_accept_pressed(_cell: Vector2i) -> void:
	if unit:
		_state_machine.transition_to("OptionActionState", {"unit": unit})


func _on_Cursor_move(new_cell: Vector2i) -> void:
	_chek_unit_pos(new_cell)


#Essa função serve para eu saber se a existe uma unidade nessa posição
#E se existe, eu vou fazer um hover nele, e se não tiver eu disfaço o hover
#Na unidade passada
func _chek_unit_pos(pos: Vector2i) -> void:
	if unit:
		if board.is_occupied(pos):
			if unit.cell == pos:
				return
			
			if unit.is_hover:
				unit.dishover()
			
			unit = board.get_unit_by_cell(pos)
			
			unit.hover()
		else:
			if unit.is_hover:
				unit.dishover()
			
			unit = null
	else:
		if board.is_occupied(pos):
			unit = board.get_unit_by_cell(pos)
			unit.hover()
