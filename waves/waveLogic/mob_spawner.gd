class_name MobSpawner extends Node2D

@export var waves : Array[Wave]

@onready var next_wave_timer : Timer = %NextWaveTimer
@onready var next_mob_timer : Timer = %NextMobTimer


const SINGLE := preload("res://enemies/forward_shooting/forward_shooting_enemy.tscn")
const TRIPLE := preload("res://enemies/forward_shooting/triple_shot_enemy.tscn")
const AIMING := preload("res://enemies/homing_enemy/homing_enemy.tscn")
const BURST := preload("res://enemies/homing_enemy/burst_enemy.tscn")
const BEAM := preload("res://enemies/beam_enemy/beam_enemy.tscn")

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
			mob = SINGLE.instantiate()
		EnemyType.Type.TRIPLE:
			mob = TRIPLE.instantiate()
		EnemyType.Type.AIMED:
			mob = AIMING.instantiate()
		EnemyType.Type.BURST:
			mob = BURST.instantiate()
		EnemyType.Type.BEAM:
			mob = BEAM.instantiate()
		EnemyType.Type.BOSS:
			pass
	
	mob.spawn_health_pickup = current_wave.mobs[mob_index].spawn_health_pickup
	mob.rotation_degrees = current_wave.mobs[mob_index].rotation
	mob.global_position = current_wave.mobs[mob_index].spawn_position
	mob.has_died.connect(on_enemy_died)
	if mob is MovingEnemy:
		var moving_mob := mob as MovingEnemy
		moving_mob.target_position = current_wave.mobs[mob_index].target_position
		get_tree().root.add_child(moving_mob)
		enemies.append(moving_mob)
	else:
		get_tree().root.add_child(mob)
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


	
