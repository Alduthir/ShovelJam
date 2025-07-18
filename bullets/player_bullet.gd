extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.SKY_BLUE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion := %Explosions as GPUParticles2D
@onready var smoke := %Smoke as GPUParticles2D
@onready var bullet_sound : AudioStreamPlayer2D = %BulletSound

var direction : Vector2 = Vector2.RIGHT
var damaging : bool = false

func _ready() -> void:
	sprite.modulate = color

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
		Poolmanager.return_instance(self)
	
		bullet_sound.play()
		bullet_sound.finished.connect(bullet_sound.stop)
		enable_particle_effects()
		sprite.visible = false
	
func enable_particle_effects() -> void:
	explosion.global_position = global_position
	explosion.emitting = true
	smoke.global_position = global_position
	smoke.emitting = true
	explosion.reparent(get_tree().root)
	smoke.reparent(get_tree().root)
	smoke.finished.connect(func()->void:
		explosion.emitting = false
		smoke.emitting = false
		Poolmanager.return_instance(self)
	)
