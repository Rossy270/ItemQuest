extends BoardState

var attack: Attack
var attack_info: AttackInfo
var unit: Unit


func enter(msg := {}) -> void:
	if msg.has("Attack"):
		attack = msg["Attack"]
		attack_info = attack.attack_info
		unit = attack.unit
		board.attack_range_layer.draw_attack_range(attack_info.calculate_attack_range(attack.unit_position))
		board.cursor.accept_pressed.connect(_on_Cursor_accept_pressed)
		unit.attack_finished.connect(_on_Unit_attack_finished)
	
	if attack_info.single_target:
		print("so pode atacar 1")


func exit() -> void:
	if attack:
		unit.attack_finished.disconnect(_on_Unit_attack_finished)
		attack = null
		attack_info = null
		board.attack_range_layer.clear()
		board.cursor.accept_pressed.disconnect(_on_Cursor_accept_pressed)


func _on_Cursor_accept_pressed(cell: Vector2i) -> void:
	if board.is_occupied(cell) and cell != unit.cell:
		var target_unit = board._units[cell] as Unit
		if target_unit:
			attack.unit.attack_execute(target_unit, attack_info.attack_damage)
	else:
		_back_action_state()
		


func _on_Unit_attack_finished() -> void:
	_back_action_state()


func _back_action_state() -> void:
	_state_machine.transition_to("MoveState")
