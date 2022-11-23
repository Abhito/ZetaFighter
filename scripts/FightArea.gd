extends Node2D

onready var _player1 = $Player1
onready var _player2 = $Player2
onready var _camera = $Camera2D
onready var _player1health = $CanvasLayer/Control/Player1
onready var _player2health = $CanvasLayer/Control/Player2

var characterchosen1 = load(Match.player1)
var characterchosen2 = load(Match.player2)
var stageInstance = load(Match.stage)
var lights_on = false
var moveList1 = ["left_one", "up_one", "right_one", "action1_one", "action2_one"]
var moveList2 = ["left_two", "up_two", "right_two", "action1_two", "action2_two"]



# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize()
	
	

func _initialize():
	var stage = stageInstance.instance()
	add_child(stage)
	stage.start()
	var sameCharacter = false
	if characterchosen1 == characterchosen2:
		sameCharacter = true
	var character1 = characterchosen1.instance()
	var character2 = characterchosen2.instance()
	
	_player1.add_child(character1)
	_player2.add_child(character2)
	character1._setup(character2, 1, _player1health, moveList1)
	character2._setup(character1, 2, _player2health, moveList2)
	setupHealth(character1.health, character2.health)
	if sameCharacter:
		character2._change_color()
	_camera.add_target(_player1.get_child(0))
	_camera.add_target(_player2.get_child(0))

func setupHealth(var one, var two):
	_player1health.max_value = one
	_player1health.value = one
	_player2health.max_value = two
	_player2health.value = two

func _on_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")

func _physics_process(delta):
	if _player1health.value <= 0 or _player2health.value <= 0:
		get_tree().change_scene("res://views/Menu.tscn")


