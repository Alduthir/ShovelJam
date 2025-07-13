class_name WireNode extends Area2D

@export_category("Appearance")
@export_color_no_alpha var color : Color
@export var texture : Texture2D = preload("res://engine/wires/wire_blue.png")
@export var is_flipped := false

@export var linked_node : WireNode

var line : Line2D = null
var has_mouse := false
var dragging := false
var is_connected := false : set = set_connected
var line_max_length := 220.0
var previous_mouse_position := Vector2.ZERO
var draw_length := 0.0

@onready var sprite : Sprite2D = %Sprite2D
@onready var polygon : Polygon2D = %Polygon2D

signal line_connected

func _ready() -> void:
	sprite.texture = texture
	if is_flipped:
		sprite.flip_h = true
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_released("lmb"):
		draw_length = 0.0
		dragging = false
		for child in get_children():
			if child is Line2D:
				if linked_node.has_mouse:
					is_connected = true
					linked_node.is_connected = true
				elif is_connected == false: 
					child.queue_free()
					
	if line != null and dragging:
		draw_length += previous_mouse_position.distance_to(get_global_mouse_position())
		previous_mouse_position = get_global_mouse_position()
		if draw_length < line_max_length:
			line.add_point(get_local_mouse_position())
		else : 
			for child in get_children():
				if child is Line2D:
					child.queue_free()


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb") and is_connected == false:
		dragging = true
		line = Line2D.new()
		line.z_index += 1
		line.width = 20
		line.default_color = color
		line.add_point(get_local_mouse_position())
		add_child(line)
		draw_length = 0.0
		previous_mouse_position = get_global_mouse_position()


func _on_mouse_entered() -> void:
	has_mouse = true


func _on_mouse_exited() -> void:
	has_mouse = false

func set_connected(new_value: bool) -> void:
	is_connected = new_value
	if is_connected:
		line_connected.emit()
