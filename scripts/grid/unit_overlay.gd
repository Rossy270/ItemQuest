extends TileMapLayer
class_name UnitOverlay

func draw(cells: Array) -> void:
	print("entrei aqui")
	print("celss: ", cells)
	clear()
	for cell in cells:
		print("to aqui")
		set_cell(cell, 0, Vector2i(0,0))
