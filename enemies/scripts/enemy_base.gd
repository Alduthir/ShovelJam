class_name EnemyBase
extends DamageEntityBase

@export var health : float
@export var speed : int
@export var shoot_cooldown_min : float
@export var shoot_cooldown_max : float
@export var bullet_scene : PackedScene

var can_shoot : bool = true

func _process(delta : float) -> void:
	var velocity : Vector2 = Vector2(-speed, 0)
	position += velocity * delta
	
	if can_shoot:
		can_shoot = false
		var bullet : EnemyBulletBase = bullet_scene.instantiate()
		bullet.position = position + Vector2(-100, 0)
		
		add_sibling(bullet)
		await get_tree().create_timer(randf_range(shoot_cooldown_min, shoot_cooldown_max)).timeout
		can_shoot = true
		
		
func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		queue_free()
	elif area is PlayerProjectileBase:
		health -= (area as PlayerProjectileBase).damage
		
		if health <= 0:
			# TODO: make this look cool with explosion or something
			queue_free()
		else:
			pass
			# TODO play damage sound and show some particles
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
