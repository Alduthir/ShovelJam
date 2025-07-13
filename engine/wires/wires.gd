class_name Wires extends Node2D

var wire_nodes : Array[WireNode]

signal puzzle_completed
func _ready() -> void:
	for child in get_children():
		if child is WireNode:
			var wire_node : WireNode = child as WireNode
			wire_node.line_connected.connect(check_lines)
			wire_nodes.append(wire_node)

func check_lines()->void:
	var all_lines_connected := true
	for wire_node : WireNode in wire_nodes:
		if wire_node.is_connected == false:
			all_lines_connected = false
	
	if all_lines_connected:
		puzzle_completed.emit()
