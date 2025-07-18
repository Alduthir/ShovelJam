class_name BurstEnemy extends MovingEnemy
## This enemy will first move towards its target position. Upon arriving it will start shooting forward until it dies.

@export var bullet_scene := preload("res://bullets/aimed_bullet.tscn")
@export var shots_in_burst := 3
@export var shot_cooldown := 0.05
@onready var burst_timer : Timer = %BurstTimer
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
	elif burst_timer.is_stopped():
		print("shooting in burst enemy")
		shoot_burst()
		burst_timer.start()

func shoot_burst() -> void:
	for i in shots_in_burst:
		shoot()
		await get_tree().create_timer(shot_cooldown).timeout
	

func shoot() -> void:
	var bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	bullet.initialize(shot_marker.global_position)
	shot_audio.play()
	
func _on_shot_timer_timeout() -> void:
	shoot_burst()
	
