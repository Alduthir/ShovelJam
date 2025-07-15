class_name BeamPod extends Sprite2D

@export var damage := 30.0
@export var explosion := preload("res://shared/death_explosion.tscn")

@onready var collider : CollisionShape2D = %BeamCollider
@onready var animator : AnimatedSprite2D = %Beam
@onready var beam_area : Area2D = %Area2D
@onready var shoot_timer : Timer = %ShootTimer

func _ready() -> void:
	collider.disabled = true
	
	animator.stop()
	animator.animation_finished.connect(func()->void:
		collider.disabled = true
		animator.stop()
		)
	
	beam_area.area_entered.connect(func(other : Area2D)->void:
		if other is Player:
			var player := other as Player
			player.take_damage(damage)
			
			var body_shape_2d := collider.shape
			var body_global_transform := global_transform

			var area_shape_2d : Shape2D = player.collision_shape.shape
			var area_global_transform := other.global_transform
	
			var collision_points := area_shape_2d.collide_and_get_contacts(area_global_transform,
									body_shape_2d,
									body_global_transform)
			
			
			if collision_points.is_empty() == false:
				var particles : GPUParticles2D = explosion.instantiate()
				particles.global_position = collision_points[0]
				particles.finished.connect(particles.queue_free)
				get_tree().root.add_child(particles)
				particles.emitting = true
		)	
	
	shoot_timer.timeout.connect(fire_beam)

func _process(_delta: float) -> void:
	if animator.is_playing() and animator.frame == 5 and collider.disabled:
		collider.disabled = false

func fire_beam()->void:
	animator.play("shoot_beam")
