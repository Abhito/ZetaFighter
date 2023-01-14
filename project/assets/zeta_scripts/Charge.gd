extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.hurt = false
	player.toggle_monitor(true)
	player.ischarging = true
	player.set_collision_layer_bit(1, false)
	player.set_collision_layer_bit(4, true)
	animation_player.play("Walk")
	player.dash.start_dash(player._animation_sprite, player.dash_duration, player._pivot.scale.x)

func physics_update(delta: float) -> void:
	player._jump_made = 0
	if not is_zero_approx(player.get_input_direction()):
		player._velocity.x = lerp(player._velocity.x, player.get_input_direction() * player.dash_speed, player.acceleration * delta)
		#player._velocity.x = player.get_input_direction() * player.speed
		
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	

	if player.hurt_big == true:
		charge_off()
		player.dash.duration_timer.stop()
		player.dash.duration_timer.emit_signal("timeout")
		state_machine.transition_to("Hurt", {do_more = true})
	elif player.dead:
		charge_off()
		player.dash.duration_timer.stop()
		player.dash.duration_timer.emit_signal("timeout")
		state_machine.transition_to("Hurt")
	
	if player.moves[3] and player.powered:
		charge_off()
		player.dash.duration_timer.stop()
		player.dash.duration_timer.emit_signal("timeout")
		state_machine.transition_to("Blast")
	elif not player.moves[4]:
		charge_off()
		player.dash.duration_timer.stop()
		player.dash.duration_timer.emit_signal("timeout")
		state_machine.transition_to("Idle")
	elif not player.dash.is_dashing():
		charge_off()
		state_machine.transition_to("Idle")
		
func charge_off():
	player.sprite_player.play("powered_down")
	player.ischarging = false
	player.set_collision_layer_bit(1, true)
	player.set_collision_layer_bit(4, false)
	player.toggle_monitor(false)
