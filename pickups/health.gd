class_name HealthPickup
extends Area2D

@export var speed : float = 300.0
@export var amount_to_heal_min : float = 10.0
@export var amount_to_heal_max : float = 10.0

@onready var amount_to_heal : float = randf_range(amount_to_heal_min, amount_to_heal_max)

var direction : Vector2 = Vector2.LEFT



func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		PlayerUi.heal(amount_to_heal)
		queue_free()
