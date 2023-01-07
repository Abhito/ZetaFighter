extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player._other_player.global_position = player.super_pos.global_position
	animation_player.play("Super")

func physics_update(delta: float) -> void:
	player._other_player.global_position = player.super_pos.global_position
	if not animation_player.is_playing():
		player.in_super = false
		state_machine.transition_to("Idle")
