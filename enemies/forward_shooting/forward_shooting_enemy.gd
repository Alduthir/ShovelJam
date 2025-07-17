class_name HomingEnemy extends MovingEnemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var bullet_scene := preload("res://bullets/enemy_bullet.tscn")

@onready var shot_timer : Timer = %ShotTimer
@onready var shot_marker : Marker2D = %Shotmarker
@onready var shot_audio : AudioStreamPlayer2D = %AudioStreamPlayer2D
var has_arrived := false 

func _process(delta: float) -> void:
	if has_arrived == false:
		var distance := global_position.distance_to(target_position)
		var direction := global_position.direction_to(target_position)
		position += direction * speed * delta
		if distance <= 5.0:
			has_arrived = true
	elif shot_timer.is_stopped():
		shoot()
		shot_timer.start()

func shoot() -> void:
	var bullet : Node2D = bullet_scene.instantiate()
	bullet.position = shot_marker.global_position
	add_sibling(bullet)
	shot_audio.play()
	
func _on_shot_timer_timeout() -> void:
	shoot()
	
