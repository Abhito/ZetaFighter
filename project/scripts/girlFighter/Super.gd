extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	animation_player.play("Super")

func physics_update(delta: float) -> void:
	player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	player._velocity.y = 0
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if player.spawn_blast:
		player.fireSuper()
	if not animation_player.is_playing():
		player.pause_mode = Node.PAUSE_MODE_INHERIT
		get_tree().paused = false
		player.health_bar.energy_bar.value = 0
		player.super_ready = false
		state_machine.transition_to("Idle")
