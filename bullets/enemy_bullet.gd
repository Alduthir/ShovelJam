extends Area2D

@export var damage := 10.0
@export var speed := 800.0
@export var color := Color.PURPLE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion_scene := preload("res://shared/hit_explosions.tscn")
@onready var smoke_scene := preload("res://shared/smoke.tscn")
@onready var bullet_sound : AudioStreamPlayer2D = %BulletSound

var direction : Vector2 = Vector2.LEFT
var damaging : bool = false

func _ready() -> void:
	sprite.modulate = color

func _process(delta: float) -> void:
	var rotated_direction := direction.rotated(rotation)
	position += rotated_direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	#Workaround for bullets sometimes triggering area entered twice
	if damaging:
		return
	
	damaging = true
	set_process(false)
	
	if area is Player:
		var player := area as Player		
		
		if player.can_take_damage == false:
			queue_free()
		bullet_sound.pitch_scale = randf_range(0.8,1.2)
		bullet_sound.play()
		bullet_sound.finished.connect(bullet_sound.stop)
		player.take_damage(damage)
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		set_process(false)
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
