class_name Enemy extends Area2D

@export var speed := 300.0
@export var health := 50.0
@export var explosion_effect := preload("res://shared/death_explosion.tscn")
@export var health_pickup : PackedScene = preload("res://pickups/health.tscn")

var dying := false
var spawn_health_pickup : bool = false

signal has_died(sender : Enemy)

func take_damage(amount: float)-> void:
	if dying:
		return
	health = max(health - amount, 0)
	
	if health <= 0:
		var colliders := find_children("CollisionShape2D")
		if colliders.size() > 0:
			for collider : CollisionShape2D in colliders:
				collider.set_deferred("disabled", true)
		else:
			var polygon := find_child("CollisionPolygon2D")
			if polygon:
				polygon.set_deferred("disabled", true)
				
		var sprites := find_children("Sprite2D")
		for sprite : Sprite2D in sprites:
			sprite.visible = false
		dying = true
		
		if spawn_health_pickup:
			var pickup : HealthPickup = health_pickup.instantiate()
			pickup.global_position = global_position
			add_sibling(pickup)
			
		call_deferred("set_process", false)
		var explosion : GPUParticles2D = explosion_effect.instantiate()
		add_child(explosion)
		explosion.emitting = true
		explosion.finished.connect(func()->void:
			has_died.emit(self)
			queue_free()
		)
