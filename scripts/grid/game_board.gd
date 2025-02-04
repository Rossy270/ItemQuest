extends Node2D
class_name GameBoard

signal unit_walk_finished(unit: Unit)

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const MAX_DISTANCE = 999999

@export var grid_start: Vector2i = Vector2i(0,0)
@export var grid_end: Vector2i = Vector2i(20,20)

var _units := {}
var active_unit: Unit
var _walkable_cells := []

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var unit_path: UnitPath = $UnitPath
@onready var attack_range_layer: AttackRangeLayer = $AttackRangeLayer

@onready var cursor: Cursor = $Cursor

func _ready() -> void:
	_reinitialize()


func is_occupied(cell: Vector2i) -> bool:
	return _units.has(cell)


func _reinitialize() -> void:
	_units.clear()
	
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		
		_units[unit.cell] = unit
		unit.unit_death.connect(_on_Unit_death)


func get_walkable_cells(unit: Unit) -> Array:
	return _dijkstra(unit.cell, unit.move_range)


func _dijkstra(start: Vector2i, max_distance: int) -> Array:
	var movement_costs = Grid.get_movement_costs(grid_start, grid_end)
	
	var queue = PriorityQueue.new()
	var distances = {}
	var visited = {}
	var moveable_cells = [start]
	
	for coord in movement_costs:
		distances[coord] = MAX_DISTANCE
		visited[coord] = false
		distances[start] = 0
		
	queue.push(start, 0)
	
	while not queue.is_empty():
		var current = queue.pop()
		if visited[current.value]:
			continue
		visited[current.value] = true
		
		for direction in DIRECTIONS:
			var neighbor = current.value + direction
			
			if not movement_costs.has(neighbor) or movement_costs[neighbor] >= MAX_DISTANCE:
				continue
			
			if is_occupied(neighbor):
				continue
			
			var new_cost = current.priority + movement_costs[neighbor]
			if new_cost < distances[neighbor]:
				distances[neighbor] = new_cost
				if new_cost <= max_distance:
					moveable_cells.append(neighbor)
					queue.push(neighbor, new_cost)
	
	return moveable_cells


func select_unit(cell: Vector2i) -> void:
	if not _units.has(cell):
		print("estou aqui")
		return
	
	active_unit = _units[cell]
	active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(active_unit)


func draw_walkable_cells() -> void:
	_unit_overlay.draw(_walkable_cells)
	unit_path.initialize(_walkable_cells)


func clear_walkable_cells() -> void:
	_unit_overlay.clear()
	unit_path.stop()


func deselect_active_unit() -> void:
	active_unit.is_selected = false

func clear_active_unit() -> void:
	active_unit = null
	_walkable_cells.clear()


func move_active_unit(new_cell: Vector2i) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	_units.erase(active_unit.cell)
	_units[new_cell] = active_unit
	clear_walkable_cells()
	active_unit.walk_along(unit_path.current_path)
	await active_unit.walk_finished
	unit_walk_finished.emit(active_unit)


func _on_Unit_death(cell: Vector2i) -> void:
	_units.erase(cell)


func get_unit_by_cell(cell: Vector2i) -> Unit:
	return _units.get(cell, null)
