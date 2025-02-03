extends TileMapLayer
class_name AttackRangeLayer

func draw_attack_range(attackble_cells: Array) -> void:
	clear()
	for cell in attackble_cells:
		set_cell(cell, 0, Vector2i(0,0))
