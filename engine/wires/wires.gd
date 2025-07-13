class_name Wires extends Node2D

var children : Array[WireNode]

func _ready() -> void:
	for child in get_children():
		if child is WireNode:
			children.append(child)
