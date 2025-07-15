class_name BeamEnemy extends Enemy

@export var direction : Vector2 = Vector2.LEFT

func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var children := find_children("Beam")
	var animator : AnimatedSprite2D = children[0]
	if animator.is_playing():
		await animator.animation_finished
	queue_free()
