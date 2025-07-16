class_name ShipReactor extends Node2D

@export var breaking_min_time := 10.0
@export var breaking_max_time := 20.0
@export var completed_puzzles : Array[Node2D]
@export var start_break_timer : bool

@onready var wires : Wires = %Wires
@onready var pump : Pump = %Pump
@onready var gears : Gears = %Gears
@onready var switches : Switches = %Switches
@onready var light_one : Sprite2D = %Light1
@onready var light_two : Sprite2D = %Light2
@onready var light_three : Sprite2D = %Light3
@onready var light_four : Sprite2D = %Light4
@onready var break_system_timer : Timer = %BreakSystemTimer
@onready var wire_explosions : GPUParticles2D = %WireExplosions
@onready var gear_explosions : GPUParticles2D = %GearExplosions
@onready var pump_explosions : GPUParticles2D = %PumpExplosions
@onready var switch_explosions : GPUParticles2D = %SwitchExplosions
@onready var explosion_audio : AudioStreamPlayer2D = %ExplosionAudio

var light_error := preload("res://engine/light_red.png")
var light_good := preload("res://engine/light_green.png")

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
	
	break_system_timer.timeout.connect(func () -> void: 
		break_system_timer.wait_time = randf_range(breaking_min_time, breaking_max_time)
		break_random_system()
		)
	
	#Set puzzles to completed on startup depending on scene setup	
	for puzzle : Node2D in completed_puzzles:
		if puzzle is Wires:
			wires.set_completed()
			light_one.texture = light_good
		elif puzzle is Gears:
			gears.set_completed()
			light_two.texture = light_good
		elif puzzle is Pump:
			pump.set_completed()
			light_three.texture = light_good
		elif puzzle is Switches:
			switches.set_completed()
			light_four.texture = light_good
		
	if start_break_timer:
		break_system_timer.start()

func break_random_system()->void:	
	if completed_puzzles.size() == 0:
		return
	
	var puzzle_to_break : Node2D = completed_puzzles.pick_random()
	if puzzle_to_break is Wires: 
		wires.reset_puzzle()
		light_one.texture = light_error
		wire_explosions.emitting = true
	elif puzzle_to_break is Gears:
		gears.reset_puzzle()
		light_two.texture = light_error
		gear_explosions.emitting = true
	elif puzzle_to_break is Pump:
		pump.reset_puzzle()
		light_three.texture = light_error
		pump_explosions.emitting = true
	elif puzzle_to_break is Switches:
		switches.reset_puzzle()
		light_four.texture = light_error
		switch_explosions.emitting = true
	explosion_audio.play()
	completed_puzzles.erase(puzzle_to_break)
