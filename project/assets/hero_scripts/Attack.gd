extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

export var animation: String
export var next_state: String
var action_pressed = false
var distance = 100

func enter(_msg := {}) -> void:
	if animation == "Attack3":
		distance = 300
	if player._pivot.scale.x == -1:
		player._velocity.x -= distance
	else:
		player._velocity.x += distance
	animation_player.play(animation)
	player.can_input = false
	action_pressed = false
	
func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player._velocity.x = lerp(player._velocity.x, 0, player.friction * delta * .1)
	
	player._velocity.y += player.gravity * delta
	player._velocity = player.move_and_slide(player._velocity, player.UP_Direction)
	if player.hurt == true:
		if player.hurt_big:
			state_machine.transition_to("Hurt", {do_more = true})
		else:
			state_machine.transition_to("Hurt")

	if player.moves[3]:
		action_pressed = true
	
	if next_state and player.can_input and action_pressed:
		state_machine.transition_to(next_state)
	
	if not animation_player.is_playing():
		state_machine.transition_to("Idle")
