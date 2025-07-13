class_name WireNode extends Area2D

@export_category("Bounds")
@export var line_min_x := 0
@export var line_max_x := 400
@export var line_min_y := 570
@export var line_max_y := 720

@export_category("Color")
@export_range(0,255,1) var red := 0
@export_range(0,255,1) var green := 0
@export_range(0,255,1) var blue := 255

@export var linked_node : WireNode

var line : Line2D = null
var has_mouse := false
var dragging := false
var is_connected := false

func _ready() -> void:
	modulate = Color.from_rgba8(red, green, blue)

func _process(delta: float) -> void:
	if Input.is_action_just_released("lmb"):
		dragging = false
		for child in get_children():
			if child is Line2D:
				if linked_node.has_mouse:
					is_connected = true
				elif is_connected == false: 
					child.queue_free()
					
	if line != null and dragging:
		var mouse_position := get_global_mouse_position()
		if mouse_position.x < line_max_x and mouse_position.x > line_min_x and mouse_position.y < line_max_y and mouse_position.y > line_min_y:
			line.add_point(get_local_mouse_position())


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("lmb") and is_connected == false:
		dragging = true
		line = Line2D.new()
		line.default_color = Color.from_rgba8(red, green, blue)
		line.add_point(get_local_mouse_position())
		add_child(line)


func _on_mouse_entered() -> void:
	has_mouse = true


func _on_mouse_exited() -> void:
	has_mouse = false
