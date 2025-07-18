extends Node2D

#export pools and stuff

@onready var music : AudioStreamPlayer = %Music

func _ready() -> void:
	music.finished.connect(music.play)
	# instantiate pools
