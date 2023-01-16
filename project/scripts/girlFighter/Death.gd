extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("death")

func physics_update(delta: float) -> void:
	player._velocity.x = 0
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.up_direction)
	player.hurt = false
	player.hurt_big = false
