extends BoardState


var units := {}


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		board.clear_active_unit()
		_state_machine.transition_to("SelectUnit")
	elif event.is_action_pressed("teste_mover"):
		_transition_to_move_state()
	elif event.is_action("teste_atacar"):
		pass


func enter(msg := {}) -> void:
	if msg.has("unit"):
		print(msg["unit"])
		var unit = msg["unit"]
		if not units.has(unit):
			units[unit] = {
				"move" : false,
				"attack" : false
			}
	
	print("Aperte M para mover")
	print("Aperte A para atacar")


func exit() -> void:
	pass


func _transition_to_move_state() -> void:
	if units.has(board.active_unit):
		var unit = board.active_unit
		var moved = units[unit]["move"]
		if not moved:
			_state_machine.transition_to("OptionActionState/MoveState")
			units[unit]["move"] = true
		else:
			print("A unidade já andou")
