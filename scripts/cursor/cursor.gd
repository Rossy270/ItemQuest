extends Node2D
class_name Cursor

signal accept_pressed(cell)
signal moved(new_cell)

@export var ui_cooldown := 0.1

var cell := Vector2i.ZERO:
	set(value):
		var new_cell : Vector2i = Grid.grid_clamp(value)
		
		var conf_new_cell = Vector2(new_cell.x, new_cell.y)
		var conf_cell = Vector2(cell.x, cell.y)
		
		if conf_new_cell.is_equal_approx(conf_cell):
			return
		
		cell = new_cell
		
		position = Grid.calculate_map_position(cell)
		moved.emit(cell)
		_timer.start()

@onready var _timer: Timer = $Timer

func _ready() -> void:
	if Grid.has_map():
		await Grid.map_register
	
	_timer.wait_time = ui_cooldown
	position = Grid.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cell = Grid.calculate_grid_coordinates(event.position)
	elif event.is_action_pressed("click"):
		accept_pressed.emit(cell)
		get_viewport().set_input_as_handled()
	
	var should_move := event.is_pressed()
	
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	
	if not should_move:
		return
	
	if event.is_action("move_right"):
		cell += Vector2i.RIGHT
	elif event.is_action("move_up"):
		cell += Vector2i.UP
	elif event.is_action("move_left"):
		cell += Vector2i.LEFT
	elif event.is_action("move_down"):
		cell += Vector2i.DOWN


func _draw() -> void:
	var cell_size = Grid.get_size()
	draw_rect(Rect2(-cell_size / 2, cell_size), Color.ALICE_BLUE, false, 2.0)
