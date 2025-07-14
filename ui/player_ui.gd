extends Control

@export var max_health := 100.0 

var health_bar : TextureProgressBar
var current_health : float : set = set_health
var tween : Tween

func _ready() -> void:
	health_bar = %HealthBar
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
#
func set_health(new_value: float) -> void:
	current_health = clampf(new_value, 0, max_health)
	
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(health_bar, "value", current_health, 1.0).set_ease(Tween.EASE_OUT)
