extends Node2D

const HOVER = "hover"
const FLY = "fly"
const GAME_SCENE := "res://game_scene.tscn"

@export var liftoff_sound : AudioStream = preload("res://external_assets/bart/warp engine engage_0-16bit.wav")
@export var fly_sound : AudioStream = preload("res://external_assets/circlerun/Laser Sound 3 VOL Up.mp3")

@onready var ship_reactor : ShipReactor = %ShipReactor
@onready var ship : Sprite2D = %Ship
@onready var animator : AnimationPlayer = %AnimationPlayer
@onready var music : AudioStreamPlayer = %Music
@onready var sfx : AudioStreamPlayer = %SFX

func _ready() -> void:
	PlayerUi.visible = true
	ship_reactor.completed_puzzles.clear()
	music.finished.connect(music.play)
	animator.play(HOVER)

func _process(_delta: float) -> void:
	if ship_reactor.completed_puzzles.size() == 4 and animator.current_animation != FLY:
		animator.play(FLY)
		animator.animation_finished.connect(fly_animation_finished)
		sfx.stream = liftoff_sound
		sfx.play()
		
		await get_tree().create_timer(0.9).timeout
		sfx.stream = fly_sound
		sfx.play()
	

func fly_animation_finished(_animation_name : String)->void:
	get_tree().change_scene_to_file(GAME_SCENE)
