extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
var direction = 0

func enter(_msg := {}) -> void:
	direction = 100
	if player._pivot.scale.x < 0:
		direction = -1 * direction
	animation_player.play("SuperTracking")

func physics_update(delta: float) -> void:
	player._velocity.x = lerp(player._velocity.x, direction, player.friction * delta)
	
	player._velocity.y = 0
	var c = player.move_and_collide(player._velocity)
	if c and c.collider:
		if c.collider.has_method("hit"):
			player.health_bar.energy_bar.value = 0
			player.super_ready = false
			state_machine.transition_to("Super")
		elif c.collider.has_method("is_proj"):
			pass
		else:
			player.health_bar.energy_bar.value = 0
			player.super_ready = false
			player.in_super = false
			state_machine.transition_to("Idle")
