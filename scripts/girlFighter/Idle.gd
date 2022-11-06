extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Idle")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	#player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	#player._velocity = player.move_and_slide(player._velocity, Vector2.UP)
	player._jump_made = 0
	
	if player.myNumber == 1:
		if Input.is_action_just_pressed("up_one"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_one"):
			state_machine.transition_to("Attack1")
		elif not is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Walk")
	elif player.myNumber == 2:
		if Input.is_action_just_pressed("up_two"):
			state_machine.transition_to("Jump", {do_jump = true})
		elif Input.is_action_just_pressed("action1_two"):
			state_machine.transition_to("Attack1")
		elif not is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Walk")
