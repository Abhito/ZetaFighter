extends CanvasLayer

signal particles_loaded
var  slashParticles = preload("res://materials/slashEffect.tres")
var materials = [slashParticles]

var frames = 0

func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		self.add_child(particles_instance)

func _physics_process(delta):
	if frames >= 3:
		emit_signal("particles_loaded")
	frames += 1
