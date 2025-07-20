extends CanvasLayer

var bullet_explosions := preload("res://shared/materials/bullet_explosions.tres")
var bullet_smoke := preload("res://shared/materials/bullet_smoke.tres")
var death_explosions := preload("res://shared/materials/death_explosion.tres")

var materials : Array[ParticleProcessMaterial] = [
	bullet_explosions,
	bullet_smoke,
	death_explosions
]

func _ready() -> void:
	for material in materials:
		var particles_instance := GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
