extends Bullet

@onready var animated_sprite : AnimatedSprite2D = %Sprite as AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play()
	linear_velocity = Vector2(speed, 0)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
