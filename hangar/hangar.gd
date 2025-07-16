extends Node2D

const HOVER = "hover"
const FLY = "fly"

@onready var ship_reactor : ShipReactor = %ShipReactor
@onready var ship : Sprite2D = %Ship
@onready var animator : AnimationPlayer = %AnimationPlayer
@onready var music : AudioStreamPlayer = %Music

func _ready() -> void:
	music.finished.connect(music.play)
	animator.play(HOVER)

func _process(_delta: float) -> void:
	if ship_reactor.completed_puzzles.size() == 4 and animator.current_animation != FLY:
		animator.play(FLY)
		animator.animation_finished.connect(fly_animation_finished)

func fly_animation_finished(_animation_name : String)->void:
	get_tree().change_scene_to_file("res://game_scene.tscn")
