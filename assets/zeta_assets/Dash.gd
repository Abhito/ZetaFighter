extends Node2D

var dash_delay = 3.0

onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer
var player
var ghost_scene = preload("res://assets/zeta_assets/DashGhost.tscn")
var can_dash = true
var sprite
var direction

func start_dash(sprite, duration, direction):
	self.sprite = sprite
	self.direction = direction
	player = sprite.get_child(0)
	var mat_override = sprite.material.duplicate()
	mat_override.set_shader_param("u_color_key", Color8(173, 34, 34))
	mat_override.set_shader_param("u_replacement_color", Color8(0, 0, 0))
	mat_override.set_shader_param("u_tolerance", .1)
	mat_override.set_shader_param("mix_weight", 0.4)
	mat_override.set_shader_param("whiten", true)
	sprite.material = mat_override
	
#	sprite.material.set_shader_param("mix_weight", 0.7)
#	sprite.material.set_shader_param("whiten", true)
	
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	
func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.scale.x = sprite.scale.x * direction
	ghost.scale.y = sprite.scale.y

func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	sprite.material.set_shader_param("whiten", false)
	
	can_dash = false
	yield(get_tree().create_timer(dash_delay), 'timeout')
	player.play("eye")
	can_dash = true


func _on_DurationTimer_timeout() -> void:
	end_dash()


func _on_GhostTimer_timeout():
	instance_ghost()
