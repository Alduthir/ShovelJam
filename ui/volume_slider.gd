extends HSlider

@export var audio_bus_name := "Master"
@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	value_changed.connect(_on_value_changed)


func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(new_value))
