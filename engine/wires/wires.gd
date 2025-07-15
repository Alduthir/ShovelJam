class_name Wires extends Node2D

var wire_nodes : Array[WireNode]

signal puzzle_completed
func _ready() -> void:
	for child in get_children():
		if child is WireNode:
			var wire_node : WireNode = child as WireNode
			wire_node.line_connected.connect(check_lines)
			wire_nodes.append(wire_node)
	
	for wire_node in wire_nodes:
		if wire_node.is_line_connected == false:
			for child in get_children():
				var line := Line2D.new()
				line.default_color = wire_node.color
				line.add_point(wire_node.global_position - (global_position + wire_node.position))
				line.add_point(wire_node.linked_node.position - wire_node.position)
				wire_node.add_child(line)
				wire_node.is_line_connected = true
				wire_node.linked_node.is_line_connected = true
			
func check_lines()->void:
	var all_lines_connected := true
	for wire_node : WireNode in wire_nodes:
		if wire_node.is_line_connected == false:
			all_lines_connected = false
	
	if all_lines_connected:
		puzzle_completed.emit()
		

func reset_puzzle() -> void:
	for wire_node in wire_nodes:
		if wire_node.is_line_connected:
			for child in wire_node.get_children():
				if child is Line2D:
					child.queue_free()
					wire_node.line = null
					wire_node.is_line_connected = false
					wire_node.linked_node.is_line_connected = false
