class_name PlayerBulletBase
extends PlayerProjectileBase

@export var speed : int

@onready var animated_sprite : AnimatedSprite2D = %Sprite as AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer2D = %AudioPlayer as AudioStreamPlayer2D

func _ready() -> void:
	animated_sprite.play()
	audio_player.play()
	
func _process(delta: float) -> void:
	var velocity : Vector2 = Vector2(speed, 0)
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	if area is not Player and area is not PlayerProjectileBase:
		queue_free()
		await audio_player.finished

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
