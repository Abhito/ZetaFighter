extends KinematicBody2D

const UP_Direction := Vector2.UP

export var speed := 350.0

export var jump_strength := 1200.0
export var maximum_jumps := 2
export var double_jump_strength := 800.0
export var gravity := 4000.0

const dash_speed := 800
const dash_duration := 0.2
var dash_count = 0
var dash_direction = 0

var friction = 20
var air_friction = 10
var acceleration = 60
var can_input = true
var spawn_blast = false
var hurt = false
var hurt_big = false
var health = 1500
var charge = .35
var ischarging = false
var has_sword = true
var damage_absorbed = 0

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var _pivot = get_node("Position2D")
onready var _animation_sprite = get_node("Position2D/Sprite")
onready var hand_position = get_node("Position2D/ProjPosition")
onready var dash = $Dash
onready var timer = $DashTimer
onready var ki = $Position2D/Ki
var blast = preload("res://assets/FireBolt.tscn")
var sword = preload("res://assets/Sword.tscn")

var _other_player = null
var myNumber = 0
var health_bar = null
var moveList = []


func get_input_direction() -> float:
	if not can_input:
		return 0.0
	var _horizontal_direction = 0
	_horizontal_direction = Input.get_action_strength(moveList[2]) - Input.get_action_strength(moveList[0])
	return _horizontal_direction
	
	
func _setup(_player, number, healthbar, myMoves):
	_other_player = _player
	myNumber = number
	health_bar = healthbar
	moveList = myMoves

func _change_color():
	_animation_sprite.modulate = Color8(255,200,200)
	
func ready_for_input():
	can_input = true

func ready_for_proj():
	spawn_blast = true

func hit(value):
	if ischarging:
		damage_absorbed += value * .9
		value = value * .1
		hurt = false
		if damage_absorbed > 200:
			hurt = true
		else:
			position.x -= 10 * _pivot.scale.x
	else:
		hurt = true
	if value > 150:
		hurt_big = true
	health -= value
	health_bar.value = health

func fire():
	spawn_blast = false
	var proj = blast.instance()
	proj.position = hand_position.global_position
	proj.size(0)
	if _pivot.scale.x == 1:
		proj.direction = Vector2.RIGHT
	elif _pivot.scale.x == -1:
		proj.direction = Vector2.LEFT
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)
	
func throw_sword():
	spawn_blast = false
	has_sword = false
	var proj = sword.instance()
	proj.position = hand_position.global_position
	if(hand_position.global_position.y > 600): #is grounded
		proj.setup(.1, myNumber)
	else:
		proj.setup(5, myNumber)
	if _pivot.scale.x == 1:
		proj.direction = 1
	elif _pivot.scale.x == -1:
		proj.direction = -1
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)

func sword_forced():
	has_sword = false
	var proj = sword.instance()
	proj.position = hand_position.global_position
	proj.leave(myNumber)
	if _pivot.scale.x == 1:
		proj.direction = -1
	elif _pivot.scale.x == -1:
		proj.direction = 1
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)
	
func _physics_process(delta: float) -> void:
	if !has_sword:
		$Position2D/Sword.visible = false
		jump_strength = 1200
	else:
		$Position2D/Sword.visible = true
		jump_strength = 1000
	if Input.is_action_just_pressed(moveList[0]):
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = 1 * _pivot.scale.x
	if Input.is_action_just_pressed(moveList[2]):
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = -1 * _pivot.scale.x
	_infront_check()
	manage_ki()
	
			

func manage_ki():
	ki.scale.x = charge - (damage_absorbed * .0015)
	ki.scale.y = charge - (damage_absorbed * .0015)
func _infront_check():
	if _other_player.get_global_position().x < _pivot.get_global_position().x:
		_pivot.scale.x = -1
	elif _other_player.get_global_position().x > _pivot.get_global_position().x:
		_pivot.scale.x = 1
		


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == _other_player:
		_other_player.hit(40)


func _on_DashTimer_timeout():
	dash_count = 0


func _on_SwordChecker_body_entered(body):
	if body.has_method("sword_found"):
		if body.player == myNumber && body.is_powered:
			body.sword_found()
			has_sword = true
