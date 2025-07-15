class_name Enemy extends Area2D

@export var speed := 300.0
@export var health := 50.0
@export var explosion_effect := preload("res://shared/death_explosion.tscn")
@export var sprite_node : Sprite2D

func take_damage(amount: float)-> void:
	health = max(health - amount, 0)
	
	if health <= 0:
		sprite_node.visible = false
		var explosion : GPUParticles2D = explosion_effect.instantiate()
		add_child(explosion)
		explosion.emitting = true
		explosion.finished.connect(queue_free)
