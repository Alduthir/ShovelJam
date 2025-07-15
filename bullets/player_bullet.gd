extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.SKY_BLUE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosions : GPUParticles2D = %Explosions
@onready var smoke : GPUParticles2D = %Smoke

var direction : Vector2 = Vector2.RIGHT
var damaging : bool = false
func _ready() -> void:
	sprite.modulate = color

func _process(delta: float) -> void:
	var rotated_direction := direction.rotated(rotation)
	position += rotated_direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if damaging:
		return
	damaging = true
	if area is Enemy:
		var enemy := area as Enemy
		enemy.take_damage(damage)
		set_process(false)
	sprite.visible = false
	explosions.emitting = true
	smoke.emitting = true
	smoke.finished.connect(queue_free)
