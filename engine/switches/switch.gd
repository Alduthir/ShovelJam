class_name Switch extends Area2D

var is_turned_on := true : set = set_turned_on

@onready var sprite : Sprite2D = %Sprite2D as Sprite2D
signal switch_flipped

func _ready() -> void:
	set_switch_color()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("lmb"):
		is_turned_on = !is_turned_on

func set_turned_on(new_value: bool) -> void:
	is_turned_on = new_value
	set_switch_color()
	switch_flipped.emit()

func set_switch_color() -> void:
	if is_turned_on:
		sprite.modulate = Color.from_rgba8(0,255,0)
	else: 
		sprite.modulate = Color.from_rgba8(255,255,255)
