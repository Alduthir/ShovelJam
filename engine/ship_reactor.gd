class_name ShipReactor extends Node2D

@export var breaking_min_time := 10.0
@export var breaking_max_time := 30.0

@onready var wires : Wires = %Wires
@onready var pump : Pump = %Pump
@onready var gears : Gears = %Gears
@onready var switches : Switches = %Switches
@onready var light_one : Sprite2D = %Light1
@onready var light_two : Sprite2D = %Light2
@onready var light_three : Sprite2D = %Light3
@onready var light_four : Sprite2D = %Light4

var completed_puzzles : Array[Node2D]
var light_error := preload("res://engine/light_red.png")
var light_good := preload("res://engine/light_green.png")
var timer : Timer


func _ready() -> void:
	wires.puzzle_completed.connect(func()->void:
		completed_puzzles.append(wires)
		light_one.texture = light_good
	)	
	gears.puzzle_completed.connect(func()->void:
		completed_puzzles.append(gears)
		light_two.texture = light_good
	)	
	
	pump.puzzle_completed.connect(func()->void:
		completed_puzzles.append(pump)
		light_three.texture = light_good
	)	

	switches.puzzle_completed.connect(func()->void:
		completed_puzzles.append(switches)
		light_four.texture = light_good
	)	
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = randf_range(breaking_min_time, breaking_max_time)
	timer.timeout.connect(func () -> void: 
		timer.wait_time = randf_range(breaking_min_time, breaking_max_time)
		break_random_system()
		)
	timer.start()
	
func set_completed_puzzles(new_value: int)->void:
	completed_puzzles = clamp(new_value, 0, 4)

func break_random_system()->void:	
	if completed_puzzles.size() == 0:
		return
	
	var puzzle_to_break : Node2D = completed_puzzles.pick_random()
	if puzzle_to_break is Wires: 
		wires.reset_puzzle()
		light_one.texture = light_error
	elif puzzle_to_break is Gears:
		gears.reset_puzzle()
		light_two.texture = light_error
	elif puzzle_to_break is Pump:
		pump.reset_puzzle()
		light_three.texture = light_error
	elif puzzle_to_break is Switches:
		switches.reset_puzzle()
		light_four.texture = light_error
	completed_puzzles.erase(puzzle_to_break)
