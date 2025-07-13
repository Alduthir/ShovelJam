class_name Pump extends Node2D

@onready var _gauge : Sprite2D = %Gauge as Sprite2D

var target_value := 1.0
signal puzzle_completed()

func _on_button_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb"):
		_gauge.scale.y = minf((_gauge.scale.y + 0.1), target_value)
		
	if _gauge.scale.y >= target_value:
		puzzle_completed.emit()
