class_name Gears extends Node2D

var speed := 400.0
var is_dragging := false
var degrees_rotated := 0.0 : set = update_rotated
var required_rotation := 2500.0
var is_completed := false

signal puzzle_completed

@onready var wheel := %Wheel
func _ready() -> void:
	rotation_degrees = 0.0

func _physics_process(_delta: float) -> void:
	if is_completed: 
		return
		
	if Input.is_action_just_released("lmb"):
		is_dragging = false
		
	if is_dragging and rotation_degrees < required_rotation:
		look_at(get_global_mouse_position())
	
	if visible:
		degrees_rotated = rotation_degrees

func reset_puzzle()-> void:
	is_completed = false
	degrees_rotated = 0.0
	rotation_degrees = 0.0
	
func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb"):
		is_dragging = true

func update_rotated(new_value: float) -> void:
	degrees_rotated = new_value
	
	if degrees_rotated >= required_rotation:
		puzzle_completed.emit()
		is_completed = true
