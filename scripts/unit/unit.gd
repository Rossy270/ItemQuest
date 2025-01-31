extends Path2D
class_name Unit

signal walk_finished

@export var move_range := 6
@export var move_speed := 200.0

@onready var _path_follow: PathFollow2D = $PathFollow2D
@onready var texture: Sprite2D = $PathFollow2D/Texture

var cell := Vector2i.ZERO:
	set(value):
		cell = Grid.grid_clamp(value)
var is_selected := false:
	set(value):
		is_selected = value
var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)
var previous_pos : Vector2

func _ready() -> void:
	set_process(false)
	
	cell = Grid.calculate_grid_coordinates(position)
	position = Grid.calculate_map_position(cell)
	
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
	
	previous_pos = _path_follow.global_position


func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta
	
	var direction = (global_position - previous_pos).normalized()
	
	if direction.x != 0:
		texture.flip_h = direction.x < 0
	
	previous_pos = _path_follow.global_position
	
	if _path_follow.progress_ratio >= 1.0:
		_is_walking = false
		_path_follow.progress = 0.0001
		position = Grid.calculate_map_position(cell)
		curve.clear_points()
		walk_finished.emit()


func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	
	curve.add_point(Vector2.ZERO)
	
	for point in path:
		var p = Grid.calculate_map_position(point) - position
		if p.length() > 0:
			curve.add_point(p)
	
	cell = path[-1]
	_is_walking = true
