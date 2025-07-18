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
@onready var collision_shape : CollisionShape2D = %CollisionShape

var player_frame : int
var player_animation_name : String
var sprite_size : Vector2
var screen_size_to_adjust : Vector2

var can_shoot : bool = true
var can_take_damage : bool = true : set = set_can_take_damage

var is_knocked_back := false
var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	PlayerUi.current_health = PlayerUi.max_health
	sprite_size = sprite.get_rect().size
	
	damage_cooldown.timeout.connect(func()->void:
		can_take_damage = true
		animation_player.stop()
		var shader_material : ShaderMaterial = sprite.material
		shader_material.set_shader_parameter("hit_opacity", 0.0)
		)

func _process(delta: float) -> void:
	if is_knocked_back:
		position += knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 5* delta)
		if knockback_velocity.length() < 10:
			is_knocked_back = false
	else:
		move(delta)
		shoot()
	
	clamp_position()
	
func move(delta: float) -> void:
	var velocity := Input.get_vector("move_left","move_right","move_up","move_down")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		return
	
	var multiplier := 0.25 * ship_reactor.completed_puzzles.size()
	position += (velocity * delta) * multiplier
	# TODO: if player goes up or down, rotate a slight bit to have nose of plane
	# dip up or down, shooting and everything else may be changed in that direction too

func clamp_position()->void:
	position.x = position.clamp(sprite_size / 2, screen_size - (sprite_size / 2)).x
	position.y = position.clamp(sprite_size / 2 + Vector2(0,50), Vector2(0,720) - Vector2(0,150) - (sprite_size / 2)).y
	
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
	var horizontal_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	horizontal_bullet.global_position = horizontal_bullet_marker.global_position
	horizontal_bullet.rotation_degrees = 0
	
	var up_bullet : Node2D = Poolmanager.get_instance(bullet_scene)
	up_bullet.global_position = up_bullet_marker.global_position
	up_bullet.rotation_degrees = -10
	
	var down_bullet :Node2D = Poolmanager.get_instance(bullet_scene)
	down_bullet.global_position = down_bullet_marker.global_position
	down_bullet.rotation_degrees = 10

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
		explosions.one_shot = true
		explosions.finished.connect(func()->void:
			get_tree().change_scene_to_file("res://ui/MainMenu.tscn")
		)
	else:
		damage_cooldown.start()

func set_can_take_damage(new_value: bool) -> void:
	can_take_damage = new_value
	if can_take_damage:
		collision_shape.set_deferred("disabled", false)
	else:
		collision_shape.set_deferred("disabled", true)


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		var enemy : Enemy = area as Enemy
		enemy.take_damage(30)
		take_damage(30)
		
		is_knocked_back = true
		var direction := (global_position - enemy.global_position).normalized()
		knockback_velocity = Vector2(direction.x,0.0) * 30.0
