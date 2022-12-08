extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	if _msg.has("do_more"):
		animation_player.play("ExtendedHurt")
		if player.has_sword:
			player.sword_forced()
	else:
		animation_player.play("Hurt")

func physics_update(delta: float) -> void:
	if player.dead:
		state_machine.transition_to("Death")
	player._velocity.x = 0
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	player.hurt = false
	player.hurt_big = false
	if not animation_player.is_playing():
		state_machine.transition_to("Idle")
