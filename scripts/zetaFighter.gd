
extends KinematicBody2D

const UP_Direction := Vector2.UP

export var speed := 400.0

export var jump_strength := 1000.0
export var maximum_jumps := 2
export var double_jump_strength := 900.0
export var gravity := 4000.0

const dash_speed := 500.0
const dash_duration := 2.0
var dash_count = 0
var dash_direction = 0

var friction = 20
var air_friction = 10
var acceleration = 60
var can_input = true
var spawn_blast = false
var hurt = false
var hurt_big = false
var health = 1600
var dead = false
var charge = 0
var ischarging = false
var damage_absorbed = 0
var powered = false
var charge_rate = .1

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var _pivot = get_node("Position2D")
onready var _animation_sprite = get_node("Position2D/Sprite")
onready var hand_position = get_node("Position2D/ProjPosition")
onready var dash = $Dash
onready var timer = $DashTimer
onready var ki = $Position2D/Ki
onready var sprite_player = $Position2D/Sprite/AnimationPlayer
var blast = preload("res://assets/KiProjectile.tscn")

var _other_player = null
var myNumber = 0
var health_bar = null
var moveList = []
var moves = [false, false, false, false, false]
var isAI = false
var _horizontal_direction = 0

func get_input_direction() -> float:
	if not can_input:
		return 0.0
	if !isAI:
		_horizontal_direction = 0
		_horizontal_direction = Input.get_action_strength(moveList[2]) - Input.get_action_strength(moveList[0])
	return _horizontal_direction
	
	
func _setup(_player, number, healthbar, myMoves):
	_other_player = _player
	myNumber = number
	health_bar = healthbar
	moveList = myMoves
	if myNumber == 2 and Match.aiMode:
		isAI = true
		charge_rate = 1
		dash.dash_delay = 1
	sprite_player.play("eye")
	

func _change_color():
	_animation_sprite.modulate = Color8(255,200,200)
	
func ready_for_input():
	can_input = true

func ready_for_proj():
	spawn_blast = true

func hit(value):
	if ischarging:
		hurt_big = true
	else:
		hurt = true
	if value > 150:
		hurt_big = true
	health -= value
	if health <= 0:
		health_bar.value = 0.01
		dead = true
	else:
		health_bar.value = health
		health_bar.makeShake()

func fire():
	spawn_blast = false
	var proj = blast.instance()
	proj.position = hand_position.global_position
	proj.modulate = Color8(200, 200, 400)
	proj.size(charge)
	turn_off()
	if _pivot.scale.x == 1:
		proj.direction = Vector2.RIGHT
	elif _pivot.scale.x == -1:
		proj.direction = Vector2.LEFT
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)
	
func _physics_process(delta: float) -> void:
	pressing()
	if moves[0]:
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = 1 * _pivot.scale.x
	if moves[2]:
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = -1 * _pivot.scale.x
	_infront_check()
	if charge < 4.5:
		charge += delta * charge_rate
	if charge >= 4:
		$Position2D/Ki.visible = true
		powered = true
	manage_ki()

#this method handles player input
func pressing():
	if !isAI:
		if Input.is_action_just_pressed(moveList[0]):
			moves[0] = true
		else:
			moves[0] = false
		if Input.is_action_just_pressed(moveList[1]):
			moves[1] = true
		else:
			moves[1] = false
		if Input.is_action_just_pressed(moveList[2]):
			moves[2] = true
		else:
			moves[2] = false
		if Input.is_action_just_pressed(moveList[3]):
			moves[3] = true
		else:
			moves[3] = false
		if Input.is_action_pressed(moveList[4]):
			moves[4] = true
		else:
			moves[4] = false	
		
func manage_ki():
	ki.scale.x = charge * .08 + .1
	ki.scale.y = charge * .08 + .1
				
func _infront_check():
	if _other_player.get_global_position().x < _pivot.get_global_position().x:
		_pivot.scale.x = -1
	elif _other_player.get_global_position().x > _pivot.get_global_position().x:
		_pivot.scale.x = 1
		
func isdead():
	turn_off()
	health_bar.value = 0
	
func turn_off():
	charge = 0
	powered = false
	$Position2D/Ki.visible = false

func toggle_monitor(value):
	$Position2D/ProjChecker.monitoring = value

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == _other_player:
		_other_player.hit(60)


func _on_DashTimer_timeout():
	dash_count = 0


func _on_ProjChecker_body_entered(body):
	if body.has_method("is_proj"):
		if charge < 10:
			if body.damage < 50:
				charge += body.damage/25
			else:
				charge += body.damage/50
