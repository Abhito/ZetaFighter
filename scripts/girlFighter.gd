class_name girlFighter
extends KinematicBody2D

const UP_Direction := Vector2.UP

export var speed := 350.0
var dash_speed = 1000

export var jump_strength := 1000.0
export var maximum_jumps := 2
export var double_jump_strength := 800.0
export var gravity := 4000.0
var friction = 20
var air_friction = 10
var acceleration = 60
var can_input = true
var spawn_blast = false
var hurt = false
var hurt_big = false
var health = 1000
var charge = 1
var ischarging = false
var damage_absorbed = 0

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var _pivot = get_node("Position2D")
onready var _animation_sprite = get_node("Position2D/Sprite")
onready var timer = get_node("Timer")
onready var hand_position = get_node("Position2D/ProjPosition")
var blast = preload("res://assets/KiProjectile.tscn")

var _other_player = null
var myNumber = 0
var health_bar = null

func get_input_direction() -> float:
	if not can_input:
		return 0.0
	var _horizontal_direction = 0
	if myNumber == 1:
		_horizontal_direction = Input.get_action_strength("right_one") - Input.get_action_strength("left_one")
	elif myNumber == 2:
		_horizontal_direction = Input.get_action_strength("right_two") - Input.get_action_strength("left_two")
	return _horizontal_direction
	
	
func _setup(_player, number, healthbar):
	_other_player = _player
	myNumber = number
	health_bar = healthbar

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
		hurt = true
	if value > 150:
		hurt_big = true
	health -= value
	health_bar.value = health

func fire():
	spawn_blast = false
	var proj = blast.instance()
	proj.position = hand_position.global_position
	proj.size(charge)
	charge = 1
	if _pivot.scale.x == 1:
		proj.direction = Vector2.RIGHT
	elif _pivot.scale.x == -1:
		proj.direction = Vector2.LEFT
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)
	
func _physics_process(delta: float) -> void:
#	var _horizontal_direction = 0
#	if myNumber == 1:
#		if Input.is_action_pressed("right_one"):
#			_horizontal_direction += 1
#		if Input.is_action_pressed("left_one"):
#			_horizontal_direction -= 1
#	if myNumber == 2:
#		if Input.is_action_pressed("right_two"):
#			_horizontal_direction += 1
#		if Input.is_action_pressed("left_two"):
#			_horizontal_direction -= 1
#	_velocity.x = _horizontal_direction * speed
#	_velocity.y += gravity * delta
#		#Add animation code here
#		var is_falling := _velocity.y > 0.0 and not is_on_floor()
#		var is_jumping := false
#		var is_double_jumping := false
#		var is_jump_cancelled := false
#
#		if myNumber == 1:
#			is_jumping = Input.is_action_just_pressed("up_one") and is_on_floor()
#			is_double_jumping = Input.is_action_just_pressed("up_one") and is_falling
#			is_jump_cancelled = Input.is_action_just_pressed("up_one") and _velocity.y < 0.0
#		elif myNumber == 2:
#			is_jumping = Input.is_action_just_pressed("up_two") and is_on_floor()
#			is_double_jumping = Input.is_action_just_pressed("up_two") and is_falling
#			is_jump_cancelled = Input.is_action_just_pressed("up_two") and _velocity.y < 0.0
#
#		var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
#		var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
#
#		if is_jumping:
#			_jump_made += 1
#			_velocity.y = -jump_strength
#		elif is_double_jumping:
#			_jump_made += 1
#			if _jump_made <= maximum_jumps:
#				_velocity.y = -double_jump_strength
#		elif is_jump_cancelled:
#			_velocity.y = 0.0
#		elif is_idling or is_running:
#			_jump_made = 0
#
#		_velocity = move_and_slide(_velocity, UP_Direction)
#	#
#		if !action:
#			if is_jumping or is_double_jumping:
#				_animation_sprite.play("jump")
#			elif is_running:
#				_animation_sprite.play("walk")
#			elif is_falling:
#				_animation_sprite.play("Fall")
#			elif is_idling:
#				_animation_sprite.play("Idle")
	_infront_check()
	if charge > .5:
		charge -= delta *.3
			
			
func _infront_check():
	if _other_player.get_global_position().x < _pivot.get_global_position().x:
		_pivot.scale.x = -1
	elif _other_player.get_global_position().x > _pivot.get_global_position().x:
		_pivot.scale.x = 1
		


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == _other_player:
		_other_player.hit(50)
