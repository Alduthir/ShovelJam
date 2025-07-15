class_name Player
extends Area2D

@export var speed := 400.0
@export var bullet_scene : PackedScene
@export var special_scene : PackedScene
@export var ship_reactor : ShipReactor
@export var explosion_sound : AudioStream

@onready var sprite : Sprite2D = %Sprite
@onready var shoot_cooldown : Timer = %ShootCooldownTimer
@onready var damage_cooldown : Timer = %DamageCooldownTimer
@onready var shooting_sound : AudioStreamPlayer2D = %ShootingSound
@onready var death_sound : AudioStreamPlayer2D = %DeathSound
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var horizontal_bullet_marker : Marker2D = %HorizontalBulletMarker
@onready var up_bullet_marker : Marker2D = %UpBulletMarker
@onready var down_bullet_marker : Marker2D = %DownBulletMarker
@onready var explosions : GPUParticles2D = %Explosions
@onready var animation_player : AnimationPlayer = %AnimationPlayer

var player_frame : int
var player_animation_name : String
var sprite_size : Vector2
var screen_size_to_adjust : Vector2

var can_shoot : bool = true
var can_take_damage : bool = true : set = set_can_take_damage

func _ready() -> void:
	screen_size.y -= 150 #account for the lower part of the screen being UI
	sprite_size = sprite.get_rect().size
	
	damage_cooldown.timeout.connect(func()->void:
		can_take_damage = true
		animation_player.stop()
		var shader_material : ShaderMaterial = sprite.material
		shader_material.set_shader_parameter("hit_opacity", 0.0)
		)

func _process(delta: float) -> void:
	move(delta)
	shoot()

func move(delta: float) -> void:
	var velocity := Input.get_vector("move_left","move_right","move_up","move_down")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		return
	
	var multiplier := 0.25 * ship_reactor.completed_puzzles.size()
	position += (velocity * delta) * multiplier
	
	position.x = position.clamp(sprite_size / 2, screen_size - (sprite_size / 2)).x
	position.y = position.clamp(sprite_size / 2 + Vector2(0,50), screen_size - (sprite_size / 2)).y

	# TODO: if player goes up or down, rotate a slight bit to have nose of plane
	# dip up or down, shooting and everything else may be changed in that direction too

func shoot() -> void:
	if Input.is_action_just_pressed("special"):
		# TODO: shoot special bullet/lazer/etc..
		pass
	elif Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		shooting_sound.pitch_scale = randf_range(0.9,1.1)
		shooting_sound.play()
		
		spawn_bullets()

		shoot_cooldown.start()
		await shoot_cooldown.timeout
		can_shoot = true

func spawn_bullets()-> void:
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

func take_damage(amount : float) -> void:
	if !can_take_damage:
		return
	can_take_damage = false

	animation_player.play("is_hit")
	PlayerUi.current_health = max(PlayerUi.current_health - amount, 0)
	if PlayerUi.current_health <= 0:
		set_process(false)

		death_sound.play()

		sprite.visible = false
		explosions.emitting = true
		explosions.finished.connect(queue_free)
		print("you died")
		return
		# TODO blink plane to show invunerability frames, add timer to set hit to active again
	damage_cooldown.start()

func set_can_take_damage(new_value: bool) -> void:
	can_take_damage = new_value
	if can_take_damage:
		monitorable = true
		monitoring = true
	else:
		monitorable = false
		monitoring = false
