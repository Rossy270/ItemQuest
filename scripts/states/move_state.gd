extends BoardState

func handle_input(event: InputEvent) -> void:
	if board.active_unit and event.is_action_pressed("ui_cancel"):
		board._deselect_active_unit()
		board._clear_active_unit()


func enter(msg := {}) -> void:
	board.cursor.moved.connect(_on_Cursor_moved)
	board.cursor.accept_pressed.connect(_on_Cursor_accept_pressed)
	board.unit_walk_finished.connect(_on_Unit_walk_finished)


func exit() -> void:
	board.cursor.moved.disconnect(_on_Cursor_moved)
	board.cursor.accept_pressed.disconnect(_on_Cursor_accept_pressed)
	board.unit_walk_finished.disconnect(_on_Unit_walk_finished)


func _on_Cursor_moved(new_cell: Vector2i) -> void:
	if board.active_unit and board.active_unit.is_selected:
		board.unit_path.draw(board.active_unit.cell, new_cell)


func _on_Cursor_accept_pressed(cell: Vector2i) -> void:
	if not board.active_unit:
		board.select_unit(cell)
	elif board.active_unit.is_selected:
		board.move_active_unit(cell)


func _on_Unit_walk_finished(unit: Unit) -> void:
	var attack = Attack.new(unit.cell, unit.get_attack_info(), unit)
	
	_state_machine.transition_to("AttackState", {"Attack" : attack})
