class_name EnemyBase
extends DamageEntityBase

@export var health : float
@export var speed : int
@export var shoot_cooldown_min : float
@export var shoot_cooldown_max : float
@export var bullet_scene : PackedScene

var can_shoot : bool = true

func _process(_delta : float) -> void:
	if can_shoot:
		can_shoot = false
		var bullet : EnemyBulletBase = bullet_scene.instantiate()
		bullet.position = position + Vector2(-100, 0)
		
		add_sibling(bullet)
		await get_tree().create_timer(randf_range(shoot_cooldown_min, shoot_cooldown_max)).timeout
		can_shoot = true
