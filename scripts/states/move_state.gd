extends BoardState


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_state_machine.transition_to("OptionActionState")


func enter(_msg := {}) -> void:
	board.cursor.moved.connect(_on_Cursor_moved)
	board.cursor.accept_pressed.connect(_on_Cursor_accept_pressed)
	board.unit_walk_finished.connect(_on_Unit_walk_finished)
	board.draw_walkable_cells()


func exit() -> void:
	board.cursor.accept_pressed.disconnect(_on_Cursor_accept_pressed)
	board.unit_walk_finished.disconnect(_on_Unit_walk_finished)
	board._unit_overlay.clear()
	board.unit_path.stop()


func _on_Cursor_moved(new_cell: Vector2i) -> void:
	if board.active_unit and board.active_unit.is_selected:
		board.unit_path.draw(board.active_unit.cell, new_cell)


func _on_Cursor_accept_pressed(cell: Vector2i) -> void:
	if board.active_unit.is_selected:
		board.move_active_unit(cell)
		board.cursor.moved.disconnect(_on_Cursor_moved)


func _on_Unit_walk_finished(_unit: Unit) -> void:
	_state_machine.transition_to("OptionActionState")
