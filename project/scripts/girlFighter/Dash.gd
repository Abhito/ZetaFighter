extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	if player.dash_direction < 0:
		animation_player.play("Jump")
		player.dash.start_dash(player._animation_sprite, player.dash_duration, player._pivot.scale.x)
	elif player.dash_direction > 0:
		animation_player.play("Fall")
		player.dash.start_dash(player._animation_sprite, player.dash_duration, player._pivot.scale.x)
	player.dash_count = 0
	
func physics_update(delta: float) -> void:
	if not is_zero_approx(player.get_input_direction()):
		#player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.dash_speed, player.acceleration * delta)
		player._velocity.x = player.get_input_direction() * player.dash_speed * player.Fixed_Point
		
	player._velocity.y = 0
	player._velocity = player.move_and_slide(player._velocity, player.up_direction)
	if player.hurt == true:
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")
	if not player.dash.is_dashing():
		state_machine.transition_to("Idle")
