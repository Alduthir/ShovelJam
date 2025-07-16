extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.SKY_BLUE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion_scene := preload("res://shared/hit_explosions.tscn")
@onready var smoke_scene := preload("res://shared/smoke.tscn")
@onready var bullet_sound : AudioStreamPlayer2D = %BulletSound

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
	
	bullet_sound.play()
	bullet_sound.finished.connect(bullet_sound.stop)
	sprite.visible = false
	var explosion : GPUParticles2D = explosion_scene.instantiate()
	explosion.position = global_position
	explosion.emitting = true
	var smoke : GPUParticles2D = smoke_scene.instantiate()
	smoke.position = global_position
	smoke.emitting = true
	add_sibling(explosion)
	add_sibling(smoke)
	smoke.finished.connect(func()->void:
		explosion.queue_free()
		smoke.queue_free()
		queue_free()
		)
