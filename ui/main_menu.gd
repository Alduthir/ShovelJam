extends Control

func _ready() -> void:
	PlayerUi.visible = false


func _on_play_button_pressed() -> void:
	PlayerUi.visible = true
	get_tree().change_scene_to_file("res://testlevel.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
