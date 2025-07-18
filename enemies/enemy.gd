class_name Enemy extends Area2D

@export var speed := 300.0
@export var health := 50.0
@export var health_pickup : PackedScene = preload("res://pickups/health.tscn")

@onready var explosion_effect : GPUParticles2D = %Explosions as GPUParticles2D

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
		
		for child: Timer in find_children("*", "Timer"):
			child.stop()
		
		if spawn_health_pickup:
			var pickup : HealthPickup = Poolmanager.get_instance(health_pickup)
			pickup.global_position = global_position
			Poolmanager.enable_instance(pickup)
			
		explosion_effect.emitting = true
		explosion_effect.finished.connect(func()->void:
			has_died.emit(self)
			explosion_effect.emitting = false
			Poolmanager.return_instance(self)
		)
		call_deferred("set_process", false)
