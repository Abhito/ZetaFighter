extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Super")

func physics_update(delta: float) -> void:
	player._other_player.global_position = player.super_pos.global_position
	if not animation_player.is_playing():
		state_machine.transition_to("Idle")
