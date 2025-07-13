class_name Player
extends Area2D
signal hit

@export var speed : int = 400
@export var health : float = 100

@onready var player_animation : AnimatedSprite2D = (%Sprite as AnimatedSprite2D)
@onready var player_collision : CollisionShape2D = (%CollisionShape as CollisionShape2D)
@onready var screen_size : Vector2 = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	position = position.clamp(Vector2.ZERO, screen_size)

	# TODO: if player goes up or down, rotate a slight bit to have nose of plane
	# dip up or down, shooting and everything else may be changed in that direction too


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	# TODO: take damage, destroy minor enemies and bullets on hit, give cooldown
	# all obstacles, enemies, bullets we can get hit by, should have an int/float for damage
	body.set_deferred("disabled", true)
	
func start(pos: Vector2) -> void:
	position = pos
	show()
	player_collision.disabled = false
