extends Node

## Godot doesn't support specifying nested dicts in other dicts (Dictionary[String, Dictionary[PackedScene, int]]) which is why we will use the PackedScene's name as the key
@export var pool_entries: Dictionary[PackedScene, int] = {}

var pools: Dictionary[String, Array] = {}

var default_location: Vector2 = Vector2.INF

func _ready() -> void:
	for scene in pool_entries:
		create_pool(scene)

func create_pool(scene: PackedScene) -> void:
	if scene:
		var key := scene.resource_path.get_file().get_basename()
		if pools.has(key):
			push_warning("Duplicate pool key: %s (ignored)" % key)
			return

		pools[key] = []
		
		var parent : Node2D = Node2D.new()
		parent.name = key
		add_child(parent)

		for i in pool_entries[scene]:
			var instance: Node2D = scene.instantiate()
			disable_instance(instance)
			parent.add_child(instance)
			pools[key].append(instance)
	else:
		push_error("Invalid scene in pool entry: %s" % str(scene))

func get_instance(key: PackedScene) -> Node2D:
	var key_name: String = key.resource_path.get_file().get_basename()
	
	if not pools.has(key_name):
		create_pool(key)

	for obj: Node2D in pools[key_name]:
		if not obj.visible:
			var first: Node2D = pools[key_name].pop_front()
			pools[key_name].append(first)
			enable_instance(obj)
			return obj

	var instance: Node2D= key.instantiate()
	var parent: Node2D = get_node(key_name)
	parent.add_child(instance)
	pools[key_name].append(instance)
	return instance

func return_instance(node: Node2D) -> void:
	disable_instance(node)
	
func disable_instance(instance: Node2D) -> void:
	instance.set_deferred("visible", false)
	instance.position = default_location
	instance.set_process(false)
	instance.set_physics_process(false)
	instance.set_process_input(false)
	instance.set_process_unhandled_input(false)
	instance.set_process_unhandled_key_input(false)
	for child in instance.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", true)

func enable_instance(instance: Node2D) -> void:
	instance.set_process(true)
	instance.set_physics_process(true)
	instance.set_process_input(true)
	instance.set_process_unhandled_input(true)
	instance.set_process_unhandled_key_input(true)
	for child in instance.get_children():
		child.set_process(true)
		child.set_physics_process(true)
		if child is CanvasItem:
			(child as CanvasItem).visible = true
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", false)
	instance.set_deferred("visible", true)

func disable_all() -> void:
	for pool: Array in pools.values():
		for instance: Node2D in pool:
			disable_instance(instance)
