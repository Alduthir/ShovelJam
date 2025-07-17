class_name Pump extends Node2D

@onready var gauge : Sprite2D = %Gauge as Sprite2D
@onready var button_sprite : Sprite2D = %ButtonSprite
@onready var audio : AudioStreamPlayer2D = %AudioStreamPlayer2D

var button_pressed : Texture = preload("res://engine/pump/pump_button_down.png")
var button_released : Texture = preload("res://engine/pump/pump_button_up.png")
var is_completed := false
var empty_rotation_degrees := -125.0
var full_rotation_degrees := 125.0

var tween : Tween  = null

signal puzzle_completed()	

func _process(delta: float) -> void:
	if gauge.rotation_degrees < full_rotation_degrees:
		gauge.rotation_degrees = move_toward(gauge.rotation_degrees, -125, delta * 20)	

func _on_button_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if is_completed:
		return
	if Input.is_action_just_pressed("lmb"):
		button_sprite.texture = button_pressed
		
		var random_degree := randi_range(15,30)
		
		if gauge.rotation_degrees < full_rotation_degrees:
			if tween != null:
				tween.stop()
			tween = create_tween()
			var new_val := minf(gauge.rotation_degrees + random_degree, full_rotation_degrees)
			tween.tween_property(gauge, "rotation_degrees", new_val, 0.05).set_trans(Tween.TRANS_BOUNCE)
			#gauge.rotation_degrees = mini(gauge.rotation_degrees + random_degree, full_rotation_degrees)
		
		if gauge.rotation_degrees >= full_rotation_degrees:
			puzzle_completed.emit()
			is_completed = true
		
		var completion_percent := (gauge.rotation_degrees / full_rotation_degrees) * 100
		audio.pitch_scale = 0.8 + (0.0004 * completion_percent)
		audio.play()
	elif  Input.is_action_just_released("lmb"):
		button_sprite.texture = button_released

func set_completed()->void:
	is_completed = true
	gauge.rotation_degrees = full_rotation_degrees
	
func reset_puzzle()->void:
	gauge.rotation_degrees = empty_rotation_degrees
	is_completed = false
	button_sprite.texture = button_released
