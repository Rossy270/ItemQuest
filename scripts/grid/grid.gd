extends Node

signal map_register

var _current_map: Map


func set_current_map(map: TileMapLayer) -> void:
	if map == _current_map:
		return
	
	_current_map = map
	
	map_register.emit()


func has_map() -> bool:
	return _current_map != null


func calculate_map_position(grid_position: Vector2i) -> Vector2:
	return _current_map.map_to_local(grid_position)


func calculate_grid_coordinates(map_position: Vector2) -> Vector2i:
	return _current_map.local_to_map(map_position)


func is_within_bounds(cell_coordinates: Vector2i) -> bool:
	return _is_valid_tile(cell_coordinates)


func get_size() -> Vector2:
	return _current_map.tile_set.tile_size


func get_moveable_cells() -> PackedVector2Array:
	return _current_map.get_used_cells_by_id(0)


func as_index(cell: Vector2i) -> int:
	var size = _current_map.get_used_rect().size
	return cell.x + size.x * cell.y


func grid_clamp(grid_position: Vector2i) -> Vector2i:
	if _is_valid_tile(grid_position):
		return grid_position
	
	return _find_nearest_valid_tile(grid_position)


func get_movement_costs(grid_start: Vector2i, grid_end: Vector2i) -> Dictionary:
	return _current_map.get_movement_costs(grid_start, grid_end)


func _is_valid_tile(grid_position: Vector2i) -> bool:
	var tile_data = _current_map.get_cell_tile_data(grid_position)
	if tile_data and tile_data.get_custom_data("cost") > 0:
		return true
	return false


func _find_nearest_valid_tile(grid_position: Vector2i) -> Vector2i:
	var max_radius = 10
	var nearest_tile = grid_position
	var min_distance = INF
	
	for radius in range(1, max_radius + 1):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				if abs(x) != radius and abs(y) != radius:
					continue
				
				var cell = Vector2i(grid_position.x + x, grid_position.y + y)
				
				if _is_valid_tile(cell):
					var distance = grid_position.distance_to(cell)
					if distance < min_distance:
						min_distance = distance
						nearest_tile = cell
		
		if min_distance != INF:
			return nearest_tile
	
	return grid_position
