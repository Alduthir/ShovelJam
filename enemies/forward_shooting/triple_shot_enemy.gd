class_name TripleShot extends MovingEnemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var bullet_scene := preload("res://bullets/enemy_bullet.tscn")

@onready var shot_timer : Timer = %ShotTimer
@onready var horizontal_bullet_marker : Marker2D = %HorizontalBulletMarker
@onready var up_bullet_marker : Marker2D = %UpBulletMarker
@onready var down_bullet_marker : Marker2D = %DownBulletMarker

func _process(delta: float) -> void:
	var distance := global_position.distance_to(target_position)
	
	if distance > 3.0:
		var direction := global_position.direction_to(target_position)
		position += direction * speed * delta
	elif shot_timer.is_stopped():
		shoot()
		shot_timer.start()

func shoot() -> void:
	#horizontal bullet
		var bullet : Node2D = bullet_scene.instantiate()
		bullet.position = horizontal_bullet_marker.global_position
		add_sibling(bullet)
	#up bullet
		bullet = bullet_scene.instantiate()
		bullet.position = up_bullet_marker.global_position
		bullet.rotation_degrees = -10
		add_sibling(bullet)
	#down bullet
		bullet = bullet_scene.instantiate()
		bullet.position = down_bullet_marker.global_position
		bullet.rotation_degrees = 10
		add_sibling(bullet)
	
func _on_shot_timer_timeout() -> void:
	shoot()
	
