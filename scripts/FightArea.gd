extends Node2D

onready var _player1 = $Player1
onready var _player2 = $Player2
onready var _camera = $Camera2D
var characterchosen1 = preload("res://assets/girlFighter.tscn")
var characterchosen2 = preload("res://assets/girlFighter.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize()
	
	

func _initialize():
	var sameCharacter = false
	if characterchosen1 == characterchosen2:
		sameCharacter = true
	var character1 = characterchosen1.instance()
	var character2 = characterchosen2.instance()
	_player1.add_child(character1)
	_player2.add_child(character2)
	character1._setup(character2, 1)
	character2._setup(character1, 2)
	if sameCharacter:
		character2._change_color()
	_camera.add_target(_player1.get_child(0))
	_camera.add_target(_player2.get_child(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
