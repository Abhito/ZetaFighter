extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Fall")
	
func physics_update(delta: float) -> void:
	if player.frozen:
		if player.hurt == true:
			if player.hurt_big:
				state_machine.transition_to("Hurt", {do_more = true})
			else:
				state_machine.transition_to("Hurt")
		return
	if not is_zero_approx(player.get_input_direction()):
		#player._velocity.x = player.get_input_direction() * player.speed
		player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	else:
		player._velocity.x = lerp(player._velocity.x, 0, player.air_friction * delta)
		
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	if player.hurt == true:
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")
	if player.moves[4]:
		state_machine.transition_to("Charge")
	elif player.dash_count > 1 && player.dash.can_dash:
		state_machine.transition_to("Dash")
	elif player.moves[1]:
		state_machine.transition_to("Jump", {do_jump = true})
	elif player.moves[3]:
		state_machine.transition_to("Attack1")
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
