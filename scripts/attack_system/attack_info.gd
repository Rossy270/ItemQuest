extends Resource
class_name AttackInfo

enum PATTERN {SQUARE, DIAMOND, LINE, CROSS, CIRCLE, SPLASH}
enum TARGET {TEAM, ENEMY}

@export var attack_range := 3
@export var attack_pattern := PATTERN.SQUARE
@export var attack_damage := 1
@export var single_target := true
@export var target := TARGET.TEAM

func calculate_attack_range(unit_position: Vector2i) -> Array:
	match attack_pattern:
		PATTERN.SQUARE:
			return _calcutae_square_range(unit_position)
		PATTERN.DIAMOND:
			return _calculate_diamong_range(unit_position)
		PATTERN.LINE:
			return _calculate_line_range(unit_position)
		PATTERN.CROSS:
			return _calcuate_cross_attack(unit_position)
		PATTERN.CIRCLE:
			return _calculate_circule_attack(unit_position)
		PATTERN.SPLASH:
			return _calculate_splash_attack(unit_position)
		_:
			return []


func _calcutae_square_range(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for x in range(-attack_range, attack_range + 1):
		for y in range(-attack_range, attack_range + 1):
			var cell = unit_position + Vector2i(x,y)
			if Grid.is_within_bounds(cell):
				attackble_cells.append(cell)
	
	return attackble_cells


func _calculate_diamong_range(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for x in range(-attack_range, attack_range + 1):
		for y in range(-attack_range, attack_range + 1):
			if abs(x) + abs(y) <= attack_range:
				var cell = unit_position + Vector2i(x,y)
				if Grid.is_within_bounds(cell):
					attackble_cells.append(cell)
	
	return attackble_cells


func _calculate_line_range(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
		for i in range(1, attack_range + 1):
			var cell = unit_position + dir * i
			if Grid.is_within_bounds(cell):
				attackble_cells.append(cell)
	
	return attackble_cells


func _calcuate_cross_attack(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for i in range(1, attack_range + 1):
		var cell_right = unit_position + Vector2i(i, 0)
		var cell_left = unit_position + Vector2i(-i, 0)
		var cell_down = unit_position + Vector2i(0,i)
		var cell_up = unit_position + Vector2i(0, -1)
		
		if Grid.is_within_bounds(cell_right):
			attackble_cells.append(cell_right)
		
		if Grid.is_within_bounds(cell_left):
			attackble_cells.append(cell_left)
		
		if Grid.is_within_bounds(cell_down):
			attackble_cells.append(cell_down)
		
		if Grid.is_within_bounds(cell_up):
			attackble_cells.append(cell_up)
	
	return attackble_cells


func _calculate_circule_attack(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for x in range(-attack_range, attack_range + 1):
		for y in range(-attack_range, attack_range + 1):
			var distance = sqrt(x*x + y*y)
			if distance <= attack_range:
				var cell = unit_position + Vector2i(x, y)
				if Grid.is_within_bounds(cell):
					attackble_cells.append(cell)
	
	return attackble_cells


func _calculate_splash_attack(unit_position: Vector2i) -> Array:
	var attackble_cells: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1,2):
			var cell = unit_position + Vector2i(x, y)
			if Grid.is_within_bounds(cell):
				attackble_cells.append(cell)
	
	return attackble_cells
