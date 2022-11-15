extends PlayerState

export (NodePath) var _animation_sprite
onready var animation_sprite:AnimatedSprite = get_node(_animation_sprite)
export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	player.ischarging = true
	animation_sprite.visible = true
	animation_player.play("Charge")

func physics_update(delta: float) -> void:
	if player.charge < 5:
		player.charge += delta * 1.2
	if player.is_on_floor():
		player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta)
	
	
	player._velocity.y += player.gravity * delta * .3
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	
	if player.hurt == true:
		player.damage_absorbed = 0
		animation_sprite.visible = false
		player.ischarging = false
		state_machine.transition_to("Hurt", {do_more = true})
	
	if Input.is_action_just_pressed(player.moveList[3]):
		animation_sprite.visible = false
		player.ischarging = false
		player.damage_absorbed = 0
		state_machine.transition_to("Blast")
	elif not Input.is_action_pressed(player.moveList[4]):
		player.damage_absorbed = 0
		animation_sprite.visible = false
		player.ischarging = false
		state_machine.transition_to("Idle")
