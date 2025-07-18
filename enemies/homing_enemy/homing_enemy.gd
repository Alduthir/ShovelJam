class_name ForwardShootingEnemy extends MovingEnemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var bullet_scene := preload("res://bullets/aimed_bullet.tscn")

@onready var shot_timer : Timer = %ShotTimer
@onready var shot_marker : Marker2D = %Shotmarker
@onready var shot_audio : AudioStreamPlayer2D = %AudioStreamPlayer2D

func _process(delta: float) -> void:
	if target_position == Vector2.ZERO:
		return
	
	if has_arrived == false:
		var distance := global_position.distance_to(target_position)
		var direction := global_position.direction_to(target_position)
		position += direction * speed * delta
		if distance <= 5.0:
			has_arrived = true
	elif shot_timer.is_stopped():
		print("shooting in homing enemy")
		shoot()
		shot_timer.start()

func shoot() -> void:
	var bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	bullet.initialize(shot_marker.global_position)
	shot_audio.play()
	
func _on_shot_timer_timeout() -> void:
	shoot()
	
