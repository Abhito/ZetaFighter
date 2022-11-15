extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	if _msg.has("do_jump"):
		if(player._jump_made == 0):
			player._velocity.y = -player.jump_strength
		elif player._jump_made > 0:
			if player._jump_made < player.maximum_jumps:
				player._velocity.y = -player.double_jump_strength
		player._jump_made += 1
		animation_player.play("Jump")
		
func physics_update(delta: float) -> void:
		
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
			
	if Input.is_action_pressed(player.moveList[4]):
		state_machine.transition_to("Charge")
	elif player.dash_count > 1 && player.dash.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed(player.moveList[1]):
		state_machine.transition_to("Jump", {do_jump = true})
	elif Input.is_action_just_pressed(player.moveList[3]):
		if(player.has_sword):
			state_machine.transition_to("AttackSword1")
		else:
			state_machine.transition_to("Attack1")
		
	if player._velocity.y > 0.0 and not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
