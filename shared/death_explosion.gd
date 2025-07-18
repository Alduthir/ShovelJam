class_name DeathExplosion
extends GPUParticles2D



func _on_finished() -> void:
	queue_free()
