extends TileMapLayer
class_name Map

func _ready() -> void:
	Grid.set_current_map(self)


func get_movement_costs(grid_start: Vector2i, grid_end: Vector2i) -> Dictionary:
	var costs = {}
	for y in range(grid_start.y, grid_end.y + 1):
		for x in range(grid_start.x, grid_end.x):
			var coord = Vector2i(x,y)
			var data = get_cell_tile_data(coord)
			if data:
				var cost = data.get_custom_data("cost")
				costs[coord] =  cost if cost > 0 else 999999
			else:
				costs[coord] = 999999
	
	return costs
