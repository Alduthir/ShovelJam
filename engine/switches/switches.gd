class_name Switches extends Node2D

var switches : Array[Switch]
var is_completed := false

signal puzzle_completed

func _ready() -> void:
	for child in get_children():
		if child is Switch:
			var switch : Switch = child as Switch
			switches.append(child)
			switch.switch_flipped.connect(check_all_switches_on)

func reset_puzzle() -> void:
	is_completed = false
	var switches_turned_off := 0
	while switches_turned_off < 3:
		var random_switch : Switch = switches[randi_range(0,5)]
		if random_switch.is_turned_on:
			random_switch.is_turned_on = false
			switches_turned_off += 1

func check_all_switches_on() -> void:
	if is_completed:
		return
		
	var all_switches_on := true
	for switch in switches:
		if switch.is_turned_on == false:
			all_switches_on = false
	
	if all_switches_on:
		puzzle_completed.emit()
		is_completed = true
	
