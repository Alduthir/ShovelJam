class_name Player
extends Area2D
signal hit

@export var speed : int = 400
@export var health : float = 100
@export var bullet_scene : PackedScene
@export var special_scene : PackedScene

@onready var player_animation : AnimatedSprite2D = %Sprite as AnimatedSprite2D
@onready var player_collision : CollisionShape2D = %CollisionShape as CollisionShape2D
@onready var shoot_cooldown : Timer = %ShootCooldownTimer as Timer
@onready var damage_cooldown : Timer = %DamageCooldownTimer as Timer
@onready var bullet_sound : AudioStreamPlayer2D = %BulletAudioStream as AudioStreamPlayer2D

@onready var screen_size : Vector2 = get_viewport_rect().size

var player_frame : int
var player_animation_name : String
var player_texture_size : float
var sprite_size : Vector2
var screen_size_to_adjust : Vector2

var can_shoot : bool = true
var can_take_damage : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	shoot()


func move(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		player_animation.play()
	else:
		player_animation.stop()

	position += velocity * delta
	# TODO: make more efficient if we notice a big performance dip
	if player_frame != player_animation.get_frame() or player_animation_name != player_animation.animation:
		player_frame = player_animation.get_frame()
		player_animation_name = player_animation.animation
		sprite_size = player_animation.sprite_frames.get_frame_texture(player_animation_name, player_frame).get_size() * player_animation.get_scale()
		
	position = position.clamp(sprite_size / 2, screen_size - (sprite_size / 2))

	# TODO: if player goes up or down, rotate a slight bit to have nose of plane
	# dip up or down, shooting and everything else may be changed in that direction too

func shoot() -> void:
	if Input.is_action_just_pressed("special"):
		# TODO: shoot special bullet/lazer/etc..
		pass
	elif Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		var bullet : PlayerBullet = bullet_scene.instantiate()
		# TODO: if nose tipping is added, add that tipping rotation to the bullet's rotation
		bullet.position = position + Vector2(100, 0)
		
		
		add_sibling(bullet)
		shoot_cooldown.start()
		await shoot_cooldown.timeout
		can_shoot = true

func _on_body_entered(body: Node2D) -> void:
	if !can_take_damage:
		pass
	can_take_damage = false
	hit.emit()

	if body is DamageEntityBase:
		var damage_base : DamageEntityBase = body as DamageEntityBase
		health -= damage_base.damage
		if health <= 0:
			print("you died")
			hide()
			# TODO: death logic here
			
		print(health)
		# TODO blink plane to show invunerability frames, add timer to set hit to active again
		await damage_cooldown.timeout
		can_take_damage = true
	
func start(pos: Vector2) -> void:
	position = pos
	show()
	player_collision.disabled = false
