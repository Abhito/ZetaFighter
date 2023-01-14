extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.health_bar.energy_bar.value = 0
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	player.in_super = true
	player.super_ready = false
	animation_player.play("Super")

func physics_update(delta: float) -> void:
	player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	player._velocity.y = 0
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if player.spawn_blast:
		player.pause_mode = Node.PAUSE_MODE_INHERIT
		get_tree().paused = false
		player.super()
	
	if player.hurt and not animation_player.is_playing():
		player.despawn_Super()
		player.super_done = false
		player.in_super = false
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")
			
	if player.super_done and not animation_player.is_playing():
		player.super_done = false
		player.in_super = false
		state_machine.transition_to("Idle")
