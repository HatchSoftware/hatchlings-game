class_name HealthComponent
extends Node

@export_range(1, 100, 1, "or_greater") var max_hp: int = 100:
	set = _set_max_health

var hp: int = max_hp:
	set = _set_health

signal no_hp
signal hp_changed(value: int)
signal max_hp_changed(value: int)


func _ready():
	max_hp = max_hp  # trigger HP signals immediately


func _set_health(val: int):
	hp = clamp(val, 0, max_hp)
	hp_changed.emit(hp)

	if hp <= 0:
		no_hp.emit()


func _set_max_health(val: int):
	max_hp = max(1, val)
	hp = min(hp, max_hp)
	max_hp_changed.emit(hp)
