extends Node2D

@export var game_stats: GameStats = preload("res://resources/game_stats.tres")
@export var entity: PackedScene = preload("res://scenes/actors/enemy/enemy.tscn")
@export var max_spawned := 0

@onready var spawned_entities_node: Node2D = $SpawnedEntities
@onready var timer: Timer = %Timer


var locations: Array

signal spawned(target)


func _ready():
	locations = ($SpawnPoints as Node2D).get_children().map(func(n): return n.global_position)

	# Example of how we can easily curve difficulty if we so wish
	game_stats.score_changed.connect(func(val):
		if val % 3 == 0:
			timer.wait_time = max(timer.wait_time * 0.90, 0.1)
	)


func _on_timer_timeout():
	try_spawn_mob()


func try_spawn_mob() -> void:
	if spawned_entities_node.get_child_count() >= max_spawned: return

	var spawn_location = locations.pick_random()
	if spawn_location:
		var mob = entity.instantiate()
		spawned_entities_node.add_child(mob)
		mob.global_position = spawn_location
