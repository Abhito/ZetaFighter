extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Super")

func physics_update(delta: float) -> void:
	if not animation_player.is_playing():
		player.in_super = false
		state_machine.transition_to("Idle")
