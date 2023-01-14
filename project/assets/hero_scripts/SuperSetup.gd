extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:
	player.position.y -= 1000 * delta
	if player.position.y < -600:
		player.global_position.x = player._other_player.global_position.x
		state_machine.transition_to("SuperLanding")
