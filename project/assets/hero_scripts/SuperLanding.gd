extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	player.set_collision_layer_bit(1, false)
	player.set_collision_mask_bit(1, false)
	player.set_collision_mask_bit(4, false)
	animation_player.play("SuperLanding")

func physics_update(delta: float) -> void:
	player._velocity.x = 0
	player._velocity.y = 1000 * delta

	var c = player.move_and_collide(player._velocity)
	if c and c.collider:
		if c.collider.is_in_group("Ground"):
			player.pause_mode = Node.PAUSE_MODE_INHERIT
			get_tree().paused = false
			player.set_collision_layer_bit(1, true)
			player.set_collision_mask_bit(1, true)
			player.set_collision_mask_bit(4, true)
			state_machine.transition_to("Super")
			
