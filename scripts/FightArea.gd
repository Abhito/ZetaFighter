extends Node2D

onready var _player1 = $Player1
onready var _player2 = $Player2




# Called when the node enters the scene tree for the first time.
func _ready():
	_player1._setup(_player2, 1)
	_player2._setup(_player1, 2)
	$Camera2D.add_target(_player2)
	$Camera2D.add_target(_player1)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
