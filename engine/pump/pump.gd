class_name Pump extends Node2D

#@onready var _gauge : Sprite2D = %Gauge as Sprite2D

@onready var button_sprite : Sprite2D = %ButtonSprite

var button_pressed : Texture = preload("res://engine/pump/pump_button_down.png")
var button_released : Texture = preload("res://engine/pump/pump_button_up.png")

var empty_rotation_degrees := -125.0
var full_rotation_degrees := 125.0

signal puzzle_completed()


func _on_button_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb"):
		button_sprite.texture = button_pressed
	elif  Input.is_action_just_released("lmb"):
		button_sprite.texture = button_released
