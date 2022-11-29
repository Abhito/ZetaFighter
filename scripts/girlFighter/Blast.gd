extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Blast")

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	player._velocity.y += player.gravity * delta * .4
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	if player.hurt == true:
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")
	
	if player.spawn_blast:
		player.fire()
	if not animation_player.is_playing():
		state_machine.transition_to("Idle")
