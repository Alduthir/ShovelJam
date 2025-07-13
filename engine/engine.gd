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

var completed_puzzles := 0

func _ready() -> void:
	wires.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
	)	
	pump.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
	)	
	gears.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
	)	
	switches.puzzle_completed.connect(func()->void:
		completed_puzzles+=1
	)	
	

func break_random_subsystem() -> void:
	pass
