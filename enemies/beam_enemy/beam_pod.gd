class_name BeamPod extends Sprite2D

@export var damage := 30.0

@onready var explosion : GPUParticles2D = %Explosions
@onready var collider : CollisionShape2D = %CollisionShape2D
@onready var animator : AnimatedSprite2D = %Beam
@onready var beam_area : Area2D = %Area2D
@onready var shoot_timer : Timer = %ShootTimer
@onready var sfx : AudioStreamPlayer2D = %AudioStreamPlayer2D

func _ready() -> void:
	collider.disabled = true
	
	animator.stop()
	animator.animation_finished.connect(func()->void:
		collider.disabled = true
		animator.stop()
		sfx.stop()
	)
	
	beam_area.area_entered.connect(func(other : Area2D)->void:
		if other is Player:
			var player := other as Player
			player.take_damage(damage)
			
			var body_shape_2d := collider.shape
			var body_global_transform := global_transform

			var area_shape_2d : Shape2D = player.collision_shape.shape
			var area_global_transform := other.global_transform
	
			var collision_points := area_shape_2d.collide_and_get_contacts(
				area_global_transform,
				body_shape_2d,
				body_global_transform
			)
			
			if collision_points.is_empty() == false:
				explosion.global_position = collision_points[0]
				explosion.emitting = true
		)
	
	shoot_timer.timeout.connect(fire_beam)

func _process(_delta: float) -> void:
	if animator.is_playing() and animator.frame == 5 and collider.disabled:
		collider.disabled = false
		sfx.play()

func fire_beam()->void:
	animator.play("shoot_beam")
