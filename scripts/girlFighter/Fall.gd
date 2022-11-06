extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Fall")
	
func physics_update(delta: float) -> void:
		
	if not is_zero_approx(player.get_input_direction()):
		#player._velocity.x = player.get_input_direction() * player.speed
		player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	else:
		player._velocity.x = lerp(player._velocity.x, 0, player.air_friction * delta)
		
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if player.myNumber == 1:
		if Input.is_action_just_pressed("up_one"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_one"):
			state_machine.transition_to("Attack1")
	elif player.myNumber == 2:
		if Input.is_action_just_pressed("up_two"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_two"):
			state_machine.transition_to("Attack1")
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
