class_name Boss extends MovingEnemy

@export var bullet_scene := preload("res://bullets/aimed_bullet.tscn")
@export var shots_in_burst := 3
@export var shot_cooldown := 0.05
@onready var burst_timer : Timer = %BurstTimer
@onready var top_shot_marker : Marker2D = %TopShotMarker
@onready var bottom_shot_marker : Marker2D = %BottomShotMarker
@onready var shot_audio : AudioStreamPlayer2D = %AudioStreamPlayer2D

var can_rotate_pods := false : set = set_can_rotate_pods
var aim_pods_at : Vector2 = Vector2.ZERO

@export var beam_pods : Array[BeamPod]

func initialize()->void:
	for child : BeamPod in beam_pods:
		var animatedSprite : AnimatedSprite2D = child.find_child("Beam")
		animatedSprite.animation_finished.connect(func()->void:
			can_rotate_pods = true
		)
	for child : Timer in find_children("ShootTimer"):
		child.timeout.connect(func()->void:
			can_rotate_pods = false
		)

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
		shoot_burst()
		burst_timer.start()

	if can_rotate_pods:
		if aim_pods_at == Vector2.ZERO:
			var player : Player = get_tree().get_first_node_in_group("Player")
			if player != null:
				aim_pods_at = player.global_position
		
		if aim_pods_at != Vector2.ZERO:
			for child : BeamPod in beam_pods:
				child.look_at(aim_pods_at)
				child.rotation_degrees += 180

func shoot_burst() -> void:
	for i in shots_in_burst:
		shoot()
		await get_tree().create_timer(shot_cooldown).timeout
	

func shoot() -> void:
	#Top Shot
	var top_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	top_bullet.initialize(top_shot_marker.global_position)
	shot_audio.play()
	Poolmanager.enable_instance(top_bullet)
	
	#Bottom Shot
	var bottom_bullet: Node2D = Poolmanager.get_instance(bullet_scene)
	bottom_bullet.initialize(bottom_shot_marker.global_position)
	Poolmanager.enable_instance(bottom_bullet)
	shot_audio.play()

func set_can_rotate_pods(new_value : bool)->void:
	can_rotate_pods = new_value
	if new_value == false and aim_pods_at != Vector2.ZERO:
		aim_pods_at = Vector2.ZERO


func _on_burst_timer_timeout() -> void:
		shoot_burst()
