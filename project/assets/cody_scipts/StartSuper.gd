extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	player.in_super = true
	animation_player.play("StartSuper")

func physics_update(delta: float) -> void:
	player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	player._velocity.y = 0
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if not animation_player.is_playing():
		player.pause_mode = Node.PAUSE_MODE_INHERIT
		get_tree().paused = false
		state_machine.transition_to("SuperTracking")
