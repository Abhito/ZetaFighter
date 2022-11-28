extends PlayerState

export (NodePath) var _animation_sprite
onready var animation_sprite:AnimatedSprite = get_node(_animation_sprite)
export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.ischarging = true
	animation_player.play("Charge")

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if player.hurt_big == true:
		player.damage_absorbed = min(150, player.damage_absorbed)
		player.ischarging = false
		state_machine.transition_to("Hurt", {do_more = true})
	
	if player.moves[3]:
		animation_sprite.visible = false
		player.ischarging = false
		player.damage_absorbed = min(150, player.damage_absorbed)
		state_machine.transition_to("Blast")
	elif not player.moves[4]:
		player.damage_absorbed = min(150, player.damage_absorbed)
		player.ischarging = false
		state_machine.transition_to("Idle")
