extends Control

@export var click_sound : AudioStream
@export var hover_sound : AudioStream

@onready var music : AudioStreamPlayer = %Music
@onready var sfx : AudioStreamPlayer = %SFX

func _ready() -> void:
	music.finished.connect(music.play)
	PlayerUi.visible = false


func _on_play_button_pressed() -> void:
	PlayerUi.visible = true
	sfx.stream = click_sound
	sfx.play()
	sfx.finished.connect(func()->void:
		get_tree().change_scene_to_file("res://hangar/hangar.tscn")	
		)
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_mouse_entered() -> void:
	sfx.stream = hover_sound
	sfx.play()


func _on_quit_button_mouse_entered() -> void:
	sfx.stream = hover_sound
	sfx.play()
