extends Node

var character = null
var _other_player = null
var movesAI = []
var can_act = true
var pivot = 1

var move_state = false
var jump_state = false
var melee_state = false
var block_state = false
var range_state = false
onready var timer = $Timer

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if Match.aiMelee:
		timer.wait_time = .1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var turn = true
	if can_act:
		var num = 0
		if !_other_player.can_input:
			num = rng.randi_range(1,4)
			if num < 4:
				turn = false
				can_act = false
				block()
		if turn:
			num = rng.randi_range(1,4)
			var melee_range = 60
			if Match.aiMelee:
				melee_range = 100
			if num < 3:
				if abs(character.global_position.x - _other_player.global_position.x) < melee_range:
					num = rng.randi_range(1,10)
					if num > 1 or Match.aiMelee:
						turn = false
						can_act = false
						melee_attack()
					else:
						turn = false
						can_act = false
						range_attack(false)
				else:
					turn = false
					can_act = false
					range_attack(false)
			else:
				can_act = false
				move()
	movement()
	jumping()

func setup(myCharacter, other_player):
	character = myCharacter
	_other_player = other_player
	movesAI = character.moves

func range_attack(block):
	range_state = true
	if !block:
		block()
	yield(get_tree().create_timer(0.5), "timeout")
	character.moves[3] = true
	yield(get_tree().create_timer(0.05), "timeout")
	character.moves[3] = false
	range_state = false
	
func block():
	block_state = true
	character.moves[4] = true
	yield(get_tree().create_timer(1.5), "timeout")
	var num = rng.randi_range(1,10)
	if num < 3:
		range_attack(true)
	if !_other_player.can_input and num > 1:
		block()
	else:
		block_state = false
		character.moves[4] = false
		timer.start()
		
func melee_attack():
	melee_state = true
	$melee.start()
	yield(get_tree().create_timer(1.2), "timeout")
	melee_state = false
	timer.start()
	
	
func jump():
	jump_state = true
	pivot = character._pivot.scale.x
	yield(get_tree().create_timer(0.01), "timeout")
	jump_state = false

func jumping():
	if jump_state:
		character.moves[1] = true
	else:
		character.moves[1] = false
	
func move():
	move_state = true
	pivot = character._pivot.scale.x
	yield(get_tree().create_timer(0.5), "timeout")
	move_state = false
	timer.start()

func movement():
	var num = rng.randi_range(1,20)
	if move_state:
		if num == 1 && !jump_state:
			jump()
		if abs(character.global_position.x - _other_player.global_position.x) < 50:
			character._horizontal_direction = 0
		elif pivot == 1:
			if num < 3:
				character.moves[2] = true
				character.moves[0] = false
			character._horizontal_direction = 1
		elif pivot == -1:
			if num < 3:
				character.moves[2] = false
				character.moves[0] = true
			character._horizontal_direction = -1
	else:
		character.moves[2] = false
		character.moves[0] = false
		character._horizontal_direction = 0

func _on_Timer_timeout():
	can_act = true


func _on_melee_timeout():
	character.moves[3] = true
	yield(get_tree().create_timer(0.05), "timeout")
	character.moves[3] = false
	if melee_state:
		$melee.start()
