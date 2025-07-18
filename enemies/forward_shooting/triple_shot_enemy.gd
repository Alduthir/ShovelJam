class_name TripleShot extends MovingEnemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var bullet_scene := preload("res://bullets/enemy_bullet.tscn")

@onready var shot_timer : Timer = %ShotTimer
@onready var horizontal_bullet_marker : Marker2D = %HorizontalBulletMarker
@onready var up_bullet_marker : Marker2D = %UpBulletMarker
@onready var down_bullet_marker : Marker2D = %DownBulletMarker
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
		shoot()
		shot_timer.start()

func shoot() -> void:
	shot_audio.play()
	
	#horizontal bullet
	var horizontal_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	horizontal_bullet.initialize(horizontal_bullet_marker.global_position, 0)
	Poolmanager.enable_instance(horizontal_bullet)
	
	var up_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	up_bullet.initialize(up_bullet_marker.global_position, -10)
	Poolmanager.enable_instance(up_bullet)
	
	var down_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	down_bullet.initialize(down_bullet_marker.global_position, 10)
	Poolmanager.enable_instance(down_bullet)
	
func _on_shot_timer_timeout() -> void:
	shoot()
	
