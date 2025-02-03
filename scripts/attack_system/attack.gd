extends RefCounted
class_name Attack

var unit_position: Vector2i
var attack_info: AttackInfo
var unit: Unit

func _init(_pos: Vector2i, _info: AttackInfo, _unit) -> void:
	unit_position = _pos
	attack_info = _info
	unit = _unit
