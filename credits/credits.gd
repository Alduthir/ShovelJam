extends Control

@onready var music : AudioStreamPlayer = %Music

func _ready() -> void:
	music.finished.connect(music.play)
	PlayerUi.visible = false

func _on_play_again_button_pressed() -> void:
	PlayerUi.visible = true
	get_tree().change_scene_to_file("res://hangar/Hangar.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
