class_name Enemy extends Area2D

@export var speed := 300.0
@export var health := 50.0
@export var explosion_effect := preload("res://shared/death_explosion.tscn")

var dying := false

func take_damage(amount: float)-> void:
	if dying:
		return
	health = max(health - amount, 0)
	
	if health <= 0:
		var sprite : Sprite2D= find_child("Sprite2D")
		sprite.visible = false
		dying = true
		var explosion : GPUParticles2D = explosion_effect.instantiate()
		add_child(explosion)
		explosion.emitting = true
		explosion.finished.connect(queue_free)
