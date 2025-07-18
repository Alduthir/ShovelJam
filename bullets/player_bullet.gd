extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.SKY_BLUE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion := %Explosions as GPUParticles2D
@onready var smoke := %Smoke as GPUParticles2D
@onready var bullet_sound : AudioStreamPlayer = %BulletSound

var direction : Vector2 = Vector2.RIGHT
var damaging : bool = false

func _ready() -> void:
	sprite.modulate = color

func initialize(pos: Vector2, rot: int) -> void:
	damaging = false
	global_position = pos
	rotation_degrees = rot

func _process(delta: float) -> void:
	var rotated_direction := direction.rotated(rotation)
	position += rotated_direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Poolmanager.return_instance(self)

func _on_area_entered(area: Area2D) -> void:
	if damaging:
		return
	damaging = true
	if area is Enemy:
		var enemy := area as Enemy
		enemy.take_damage(damage)
		bullet_sound.play()
		enable_particle_effects()
		sprite.visible = false
	
func enable_particle_effects() -> void:
	explosion.emitting = true
	smoke.emitting = true
	smoke.finished.connect(func()->void:
		explosion.emitting = false
		smoke.emitting = false
		Poolmanager.return_instance(self)
	)
