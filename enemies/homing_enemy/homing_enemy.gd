class_name ForwardShootingEnemy extends Enemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var target_position := Vector2.ZERO
@export var bullet_scene := preload("res://bullets/aimed_bullet.tscn")

@onready var shot_timer : Timer = %ShotTimer
@onready var shot_marker : Marker2D = %Shotmarker

func _process(delta: float) -> void:
	var distance := global_position.distance_to(target_position)
	
	if distance > 3.0:
		var direction := global_position.direction_to(target_position)
		position += direction * speed * delta
	elif shot_timer.is_stopped():
		shoot()
		shot_timer.start()

func shoot() -> void:
	var bullet : Node2D = bullet_scene.instantiate()
	bullet.position = shot_marker.global_position
	add_sibling(bullet)
	
func _on_shot_timer_timeout() -> void:
	shoot()
	
