class_name PlayerBullet
extends RigidBody2D

@export var damage : int
@export var speed : int

@onready var animated_sprite : AnimatedSprite2D = %Sprite as AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer2D = %AudioPlayer as AudioStreamPlayer2D

func _ready() -> void:
	linear_velocity = Vector2(speed, 0)
	animated_sprite.play()
	audio_player.play()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
