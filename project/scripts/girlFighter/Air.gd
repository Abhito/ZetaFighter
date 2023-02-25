extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	if _msg.has("do_jump"):
		if(player._jump_made == 0):
			player._velocity.y = -player.jump_strength * player.Fixed_Point
		elif player._jump_made > 0:
			if player._jump_made < player.maximum_jumps:
				player._velocity.y = -player.double_jump_strength * player.Fixed_Point
		player._jump_made += 1
		animation_player.play("Jump")
		
func physics_update(delta: float) -> void:
	if player.frozen:
		if player.hurt == true:
			if player.hurt_big:
				state_machine.transition_to("Hurt", {do_more = true})
			else:
				state_machine.transition_to("Hurt")
		return
	if not is_zero_approx(player.get_input_direction()):
		player._velocity.x = player.get_input_direction() * player.speed * player.Fixed_Point
		#player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.speed * player.Fixed_Point, player.acceleration)
	else:
		player._velocity.x = 0
		
	player._velocity.y += player.gravity * player.Fixed_Point
	player._velocity = player.move_and_slide(player._velocity, player.up_direction)
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
		
	if player._velocity.y > 0.0 and not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
