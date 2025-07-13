extends Node

@export var enemy_scenes : Array[PackedScene]

@onready var enemy_spawn_location : PathFollow2D = %EnemySpawnLocation as PathFollow2D
@onready var enemy_spawn_timer : Timer = %EnemySpawnTimer as Timer



func _on_enemy_spawn_timer_timeout() -> void:
	var enemy_to_spawn : PackedScene = enemy_scenes.pick_random()
	var enemy : EnemyBase = enemy_to_spawn.instantiate()
	
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position
	
	enemy.linear_velocity = Vector2(-enemy.speed, 0)
	
	add_child(enemy)
