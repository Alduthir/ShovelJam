class_name MobSpawner extends Node2D

@export var waves : Array[Wave]

@export var single : PackedScene
@export var triple : PackedScene
@export var aiming : PackedScene
@export var burst : PackedScene
@export var beam : PackedScene
@export var boss : PackedScene


@onready var next_wave_timer : Timer = %NextWaveTimer
@onready var next_mob_timer : Timer = %NextMobTimer

const CREDITS_SCENE : String = "res://credits/credits.tscn"

var current_wave : Wave = null
var wave_index := 0
var mob_index := 0 : set = set_mob_index
var enemies : Array[Enemy]

func spawn_wave()->void:
	current_wave = waves[wave_index]
	mob_index = 0
	next_mob_timer.wait_time = current_wave.spawn_delay
	next_wave_timer.wait_time = current_wave.next_wave_delay
	
	if current_wave.mobs.is_empty():
		print_debug("ERROR! wave :%d  has no mobs!" % wave_index)

	next_mob_timer.start()
	pass

func spawn_mob()->void:
	var mob : Enemy
	match current_wave.mobs[mob_index].type:
		EnemyType.Type.SINGLE:
			mob = Poolmanager.get_instance(single)
		EnemyType.Type.TRIPLE:
			mob = Poolmanager.get_instance(triple)
		EnemyType.Type.AIMED:
			mob = Poolmanager.get_instance(aiming)
		EnemyType.Type.BURST:
			mob = Poolmanager.get_instance(burst)
		EnemyType.Type.BEAM:
			mob = Poolmanager.get_instance(beam)
			(mob as BeamEnemy).enable_timer()
		EnemyType.Type.BOSS:
			mob = Poolmanager.get_instance(boss)
	
	mob.spawn_health_pickup = current_wave.mobs[mob_index].spawn_health_pickup
	mob.rotation_degrees = current_wave.mobs[mob_index].rotation
	mob.global_position = current_wave.mobs[mob_index].spawn_position
	mob.has_died.connect(on_enemy_died)
	if mob is MovingEnemy:
		var moving_mob := mob as MovingEnemy
		moving_mob.has_arrived = false
		moving_mob.target_position = current_wave.mobs[mob_index].target_position
		enemies.append(moving_mob)
		if moving_mob is Boss:
			var boss := moving_mob as Boss
			boss.initialize()
	else:
		enemies.append(mob)
	mob_index += 1

func set_mob_index(new_value : int)->void:
	mob_index = new_value

	if mob_index == current_wave.mobs.size():
		wave_index+= 1
		if wave_index < waves.size():
			next_wave_timer.start()
	else:
		next_mob_timer.start()

func on_enemy_died(sender : Enemy)->void:
	enemies.erase(sender)
	if wave_index == waves.size() and enemies.size() == 0:
		get_tree().change_scene_to_file(CREDITS_SCENE)
	
func _on_next_wave_timer_timeout() -> void:
	spawn_wave()

func _on_next_mob_timer_timeout() -> void:
	spawn_mob()


	
