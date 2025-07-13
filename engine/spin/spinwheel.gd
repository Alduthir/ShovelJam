class_name SpinWheel extends Node2D

var speed := 400.0
var is_dragging := false
@onready var wheel := %Wheel

var required_rotation := 2500.0

func _ready() -> void:
	rotation_degrees = 0.0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("lmb"):
		is_dragging = false
		
	if is_dragging and rotation_degrees < required_rotation:
		look_at(get_global_mouse_position())

func reset_puzzle()-> void:
	rotation_degrees = 0.0
	


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb"):
		is_dragging = true
