extends RefCounted
class_name PathFinder

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var _astar := AStar2D.new()

func _init(walkable_cells: Array) -> void:
	var cell_mappins := {}
	for cell in walkable_cells:
		cell_mappins[cell] = Grid.as_index(cell)
	
	_add_and_connect_points(cell_mappins)
	


func calculate_point_path(start: Vector2i, end: Vector2i) -> Array:
	var start_index = Grid.as_index(start)
	var end_index = Grid.as_index(end)
	
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index, end_index)
	
	return PackedVector2Array()


func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], Vector2(point))
	
	for point in cell_mappings:
		for neighbor in _get_neighbors(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighbor)
	


func _get_neighbors(cell: Vector2i, cell_mappings: Dictionary) -> Array:
	var neighbors = []
	for direction in DIRECTIONS:
		var neighbor = cell + direction
		if cell_mappings.has(neighbor):
			neighbors.append(cell_mappings[neighbor])
	return neighbors
