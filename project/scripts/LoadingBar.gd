extends Node2D

onready var glow = $ParallaxBackground/ParallaxLayer/TextureRect/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	glow.play("glow")

