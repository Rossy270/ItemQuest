extends Resource
class_name UnitStats

@export var max_health := 10
@export var max_mana := 5
@export var move_range := 6
@export var move_speed := 200.0

var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		if health == 0:
			pass
var mana := max_mana:
	set(value):
		mana = clamp(value, 0, max_mana)


func update_health(value: int) -> void:
	health += value


func update_mana(value: int) -> void:
	mana += value


func update_max_health(value: int) -> void:
	var diff := ((health * 100) / max_health) / 100
	max_health = value
	health = max_health * diff


func update_max_mana(value: int) -> void:
	var diff := ((mana * 100) / max_mana) / 100
	max_mana = value
	mana = max_mana * diff
