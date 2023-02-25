extends SGKinematicBody2D

const Fixed_Point = 65536

export var speed := 7.0 

export var jump_strength := 30
export var maximum_jumps := 2
export var double_jump_strength := 25
export var gravity := 2.5
export var id = 1

const dash_speed := 20
const dash_duration := 0.2
var dash_count = 0
var dash_direction = 0
var up_direction := SGFixed.vector2(0, -65536)

var friction = 1
var air_friction = 10
var acceleration = 1
var can_input = true
var spawn_blast = false
var hurt = false
var hurt_big = false
var health = 1600
var dead = false
var charge = 1
var ischarging = false
var damage_absorbed = 0

var _jump_made := 0
var _velocity := SGFixedVector2.new()

onready var _pivot = get_node("Position2D")
onready var _animation_sprite = get_node("Position2D/Sprite")
onready var hand_position = $Position2D/ProjPosition
onready var super_position = get_node("Position2D/SuperPosition")
onready var dash = $Dash
onready var timer = $DashTimer
onready var ki = $Position2D/Ki
onready var attackArea = $Position2D/AttackArea
var blast = preload("res://assets/KiProjectile.tscn")
var super = preload("res://assets/girlFighterSuper.tscn")

var _other_player = null
var myNumber = 0
var health_bar = null
var moveList = []
var moves = [false, false, false, false, false, false]
var isAI = false
var _horizontal_direction: int = 0

var _camera = null
var frozen = false
var super_ready = false
onready var my_camera = $LucyCam

func _ready():
	_camera = get_node("/root/FightArea/Camera2D")

func get_input_direction() -> int:
	if not can_input:
		return 0
	if !isAI and !frozen:
		_horizontal_direction = 0
		_horizontal_direction = Input.get_action_strength(moveList[2]) - Input.get_action_strength(moveList[0])
	return _horizontal_direction
	
	
func _setup(_player, number, healthbar, myMoves):
	_other_player = _player
	myNumber = number
	health_bar = healthbar
	moveList = myMoves
	attackArea._other_player = _other_player
	if myNumber == 1:
		set_collision_layer_bit(5, true)
	else:
		set_collision_layer_bit(6, true)
	if myNumber == 2 and Match.aiMode:
		isAI = true
	

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
			hurt_big = true
		else:
			fixed_position_x -= 5 * _pivot.fixed_scale_x
			sync_to_physics_engine()
	else:
		hurt = true
	if value > 150:
		hurt_big = true
	health -= value
	#handle dying
	if health <= 0:
		health_bar.value = 0.01
		dead = true
	else:
		health_bar.value = health
		health_bar.energy_bar.value += value
		if health_bar.energy_bar.value >= health_bar.energy_bar.max_value:
			super_ready = true
		health_bar.makeShake()

func fire():
	spawn_blast = false
	var proj = blast.instance()
	proj.fixed_position = hand_position.get_global_fixed_position()
	proj.modulate = Color8(255,255,383)
	proj.size(charge)
	proj.set_target(myNumber)
	charge = 1
	if _pivot.fixed_scale_x == 65536:
		proj.direction = SGFixed.vector2(65536, 0)
	elif _pivot.fixed_scale_x == -65536:
		proj.direction = SGFixed.vector2(-65536, 0)
	get_tree().current_scene.add_child(proj)
	
func fireSuper():
	spawn_blast = false
	var proj = super.instance()
	proj.position = super_position.global_position
	proj.direct(_other_player.global_position)
	proj.add_collision_exception_with(self)
	get_tree().current_scene.add_child(proj)
	
func _physics_process(delta: float) -> void:
	pressing()
	if moves[0]:
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = 1 * _pivot.fixed_scale_x
	if moves[2]:
		timer.start()
		dash_count = dash_count + 1
		if dash_count > 1: 
			dash_direction = -1 * _pivot.fixed_scale_x
	_infront_check()
	if charge > .8:
		charge -= delta *.3
	if(damage_absorbed > 0):
		damage_absorbed -= delta * 20
	manage_ki()

#this method handles player input
func pressing():
	if frozen:
		return
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
		if Input.is_action_pressed(moveList[5]):
			moves[5] = true
		else:
			moves[5] = false
		
func manage_ki():
	ki.scale.x = charge * .08 + .1
	ki.scale.y = charge * .08 + .1
				
func _infront_check():
	if _other_player.get_global_fixed_position().x < _pivot.get_global_fixed_position().x:
		_pivot.fixed_scale_x = -65536
	elif _other_player.get_global_fixed_position().x > _pivot.get_global_fixed_position().x:
		_pivot.fixed_scale_x = 65536
		
func isdead():
	health_bar.value = 0

func looseCameraOnDeath():
	if _camera.targets.size() > 1:
		_camera.targets.remove(myNumber - 1)
	else:
		_camera.targets.remove(0)
			
func looseCamera():
	my_camera.current = false
	_camera.current = true

func getCamera():
	my_camera.current = true
	_camera.current = false


func _on_DashTimer_timeout():
	dash_count = 0
