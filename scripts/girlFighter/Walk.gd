extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Walk")
	
func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
	player._jump_made = 0
	if not is_zero_approx(player.get_input_direction()):
		player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
		#player._velocity.x = player.get_input_direction() * player.speed
		
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	if player.hurt == true:
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")
	if player.myNumber == 1:
		if Input.is_action_pressed("action2_one"):
			state_machine.transition_to("Charge")
		elif Input.is_action_just_pressed("up_one"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_one"):
			state_machine.transition_to("Attack1")
		elif is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
	elif player.myNumber == 2:
		if Input.is_action_pressed("action2_two"):
			state_machine.transition_to("Charge")
		elif Input.is_action_just_pressed("up_two"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_two"):
			state_machine.transition_to("Attack1")
		elif is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
