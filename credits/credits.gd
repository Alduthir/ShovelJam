extends Control

@onready var music : AudioStreamPlayer = %Music
@onready var sfx : AudioStreamPlayer = %SFX
@onready var play_again_button : Button = %PlayAgainButton

const HANGAR_SCENE : String = "res://hangar/hangar.tscn"
func _ready() -> void:
	music.finished.connect(music.play)
	PlayerUi.visible = false
	play_again_button.disabled = false

func _on_play_again_button_pressed() -> void:
	sfx.play()
	sfx.finished.connect(func()->void:
		get_tree().change_scene_to_file(HANGAR_SCENE)
		)
	play_again_button.disabled = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()
