extends Node2D
class_name GameBoard

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const MAX_DISTANCE = 999999

@export var grid_start: Vector2i = Vector2i(0,0)
@export var grid_end: Vector2i = Vector2i(20,20)

var _units := {}
var _active_unit: Unit
var _walkable_cells := []

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var _unit_path: UnitPath = $UnitPath
@onready var cursor: Cursor = $Cursor

func _ready() -> void:
	_reinitialize()
	cursor.moved.connect(_on_Cursor_moved)
	cursor.accept_pressed.connect(_on_Cursor_accept_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()


func is_occupied(cell: Vector2i) -> bool:
	return _units.has(cell)


func _reinitialize() -> void:
	_units.clear()
	
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		
		_units[unit.cell] = unit


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


func _select_unit(cell: Vector2i) -> void:
	if not _units.has(cell):
		return
	
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)


func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()


func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()


func _move_active_unit(new_cell: Vector2i) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	_clear_active_unit()


func _on_Cursor_moved(new_cell: Vector2i) -> void:
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)


func _on_Cursor_accept_pressed(cell: Vector2i) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)
