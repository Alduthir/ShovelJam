extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.PURPLE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion := %Explosions as GPUParticles2D
@onready var smoke := %Smoke as GPUParticles2D
@onready var bullet_sound : AudioStreamPlayer2D = %BulletSound

var direction : Vector2 = Vector2.LEFT
var damaging : bool = false

func _ready() -> void:
	sprite.modulate = color

func _process(delta: float) -> void:
	var rotated_direction := direction.rotated(rotation)
	position += rotated_direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Poolmanager.return_instance(self)

func _on_area_entered(area: Area2D) -> void:
	#Workaround for bullets sometimes triggering area entered twice
	if damaging:
		return
	
	damaging = true
	set_process(false)
	
	if area is Player:
		var player := area as Player		
		
		if player.can_take_damage == false:
			Poolmanager.return_instance(self)
		bullet_sound.pitch_scale = randf_range(0.8,1.2)
		bullet_sound.play()
		bullet_sound.finished.connect(bullet_sound.stop)
		player.take_damage(damage)
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		set_process(false)
		sprite.visible = false
		
		
# TODO: should maybe setup generic thing that is used on all bullets, or something easily callable to do this so we don't have so much duplication
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
