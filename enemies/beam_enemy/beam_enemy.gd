class_name BeamEnemy extends Enemy

@export var direction : Vector2 = Vector2.LEFT

@onready var bp1 : Sprite2D = %BeamPod
@onready var bp2 : Sprite2D = %BeamPod2
@onready var bp3 : Sprite2D = %BeamPod3
@onready var bp4 : Sprite2D = %BeamPod4
func _process(delta: float) -> void:
	position += direction * speed * delta
	if dying and bp1.visible:
		bp1.visible = false
		bp2.visible = false
		bp3.visible = false
		bp4.visible = false
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	has_died.emit(self)
	var children := find_children("Beam")
	var animator : AnimatedSprite2D = children[0]
	if animator.is_playing():
		await animator.animation_finished
	
	queue_free()
