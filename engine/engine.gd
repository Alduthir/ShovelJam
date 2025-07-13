class_name Reactor extends Node

@onready var wires : Wires = %Wires
@onready var pump : Pump = %Pump
@onready var gears : Gears = %Gears
@onready var switches : Switches = %Switches
@onready var pump_button : Button = %PumpButton
@onready var wire_button : Button = %WireButton
@onready var gear_button : Button = %GearButton
@onready var switch_button : Button = %SwitchButton
@onready var main_power : VSlider = %MainPower
@onready var light_one : Sprite2D = %Light1
@onready var light_two : Sprite2D = %Light2
@onready var light_three : Sprite2D = %Light3
@onready var light_four : Sprite2D = %Light4



var completed_puzzles := 0
var light_error := preload("res://engine/light_red.png")
var light_good := preload("res://engine/light_green.png")

func _ready() -> void:
	wires.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
		light_one.texture = light_good
	)	
	gears.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
		light_two.texture = light_good
	)	
	
	pump.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
		light_three.texture = light_good
	)	

	switches.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
		light_four.texture = light_good
	)	
	

func break_random_subsystem() -> void:
	pass
