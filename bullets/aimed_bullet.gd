extends Area2D

@export var damage := 10.0
@export var speed := 700.0
@export var color := Color.PURPLE

@onready var sprite : Sprite2D = %Sprite2D
@onready var explosion := %Explosions as GPUParticles2D
@onready var smoke := %Smoke as GPUParticles2D
@onready var bullet_sound : AudioStreamPlayer = %BulletSound
@onready var shape : CollisionShape2D = %CollisionShape2D

var damaging : bool = false
var aim_direction := Vector2.ZERO

func _ready() -> void:
	sprite.modulate = color
	

func initialize(start_pos: Vector2) -> void:
	global_position = start_pos
	var player_nodes := get_tree().get_nodes_in_group("Player")
	if !player_nodes.is_empty():
		var player : Node2D = get_tree().get_nodes_in_group("Player")[0]
		aim_direction = start_pos.direction_to(player.global_position)
	rotation = aim_direction.angle()
	Poolmanager.enable_instance(self)


func _process(delta: float) -> void:
	global_position += aim_direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Poolmanager.return_instance(self)
	aim_direction = Vector2.ZERO

func _on_area_entered(area: Area2D) -> void:
	if damaging:
		return
	
	damaging = true
	set_process(false)
	
	if area is Player:
		var player := area as Player
		
		if player.can_take_damage == false:
			Poolmanager.return_instance(self)
			aim_direction = Vector2.ZERO
			return
		bullet_sound.pitch_scale = randf_range(0.8,1.2)
		bullet_sound.play()
		bullet_sound.finished.connect(
			func() -> void:
				bullet_sound.stop()
				Poolmanager.return_instance(self)
		)
		player.take_damage(damage)
		enable_particle_effects()
		set_deferred("monitoring", false)
		set_deferred("monitorable",  false)
		set_process(false)
		sprite.visible = false
		aim_direction = Vector2.ZERO
		
		
func enable_particle_effects() -> void:
	explosion.global_position = global_position
	explosion.emitting = true
	smoke.global_position = global_position
	smoke.emitting = true
	smoke.finished.connect(func()->void:
		explosion.emitting = false
		smoke.emitting = false
		Poolmanager.return_instance(self)
	)
