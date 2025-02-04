extends Path2D
class_name Unit

signal health_changed
signal attack_finished
signal walk_finished
signal unit_death(cell: Vector2i)

@export var move_range := 6
@export var move_speed := 200.0
@export var health := 10:
	set(value):
		health = value
		health_changed.emit(health)
		if health <= 0:
			unit_death.emit(cell)
			queue_free()
@export var attacks: Array[AttackInfo]

@onready var _path_follow: PathFollow2D = $PathFollow2D
@onready var texture: Sprite2D = $PathFollow2D/Texture
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var cell := Vector2i.ZERO:
	set(value):
		cell = Grid.grid_clamp(value)
var is_selected := false:
	set(value):
		is_selected = value
		if is_selected:
			_animation_select_unit()
var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)
var previous_pos : Vector2
var is_hover := false

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


func get_attack_info() -> AttackInfo:
	return attacks[0]


func take_damage(amount: int) -> void:
	if amount > 0:
		health -= amount


func attack_execute(unit: Unit, damage: int) -> void:
	unit.take_damage(damage)
	attack_finished.emit()


func hover() -> void:
	is_hover = true
	animation_player.play("hover")


func dishover() -> void:
	is_hover = false
	animation_player.play_backwards("hover")


func _animation_select_unit() -> void:
	if is_hover:
		dishover()
		await animation_player.animation_finished
		animation_player.play("select")
	else:
		animation_player.play("select")
