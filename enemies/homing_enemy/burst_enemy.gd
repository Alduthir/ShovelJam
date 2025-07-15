class_name BurstEnemy extends Enemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var target_position := Vector2.ZERO
@export var bullet_scene := preload("res://bullets/aimed_bullet.tscn")
@export var shots_in_burst := 3
@export var shot_cooldown := 0.05
@onready var burst_timer : Timer = %BurstTimer
@onready var shot_marker : Marker2D = %Shotmarker

func _process(delta: float) -> void:
	var distance := global_position.distance_to(target_position)
	
	if distance > 3.0:
		var direction := global_position.direction_to(target_position)
		position += direction * speed * delta
	elif burst_timer.is_stopped():
		shoot_burst()
		burst_timer.start()

func shoot_burst() -> void:
	for i in shots_in_burst:
		shoot()
		await get_tree().create_timer(shot_cooldown).timeout
	

func shoot() -> void:
	var bullet : Node2D = bullet_scene.instantiate()
	bullet.position = shot_marker.global_position
	add_sibling(bullet)
	
func _on_shot_timer_timeout() -> void:
	shoot_burst()
	
