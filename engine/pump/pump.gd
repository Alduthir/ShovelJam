class_name Pump extends Node2D

@onready var _gauge := %Gauge
@onready var _button := %Button


func _on_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb"):
		_gauge.scale.y = minf((_gauge.scale.y + 0.1), 0.8)
