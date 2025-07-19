extends Node2D

@onready var music : AudioStreamPlayer = %Music

func _ready() -> void:
	music.finished.connect(music.play)


func _on_finished() -> void:
	music.stop()
