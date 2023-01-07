extends ProgressBar

onready var glow = $TextureRect/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	glow.play("glow")


