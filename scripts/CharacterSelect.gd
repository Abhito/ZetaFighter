extends Control

var list = ["default", "Lucy", "Cody"]
var characters = ["res://assets/girlFighter.tscn", "res://assets/girlFighter.tscn", "res://assets/cody.tscn"]
var num1 = 0
var num2 = 0
var total = 3
var ready1 = false
var ready2 = false

onready var ready1label = $Player1/Ready
onready var ready2label = $Player2/Ready
onready var sprite1 = $Player1/Player1
onready var label1 = $Player1/Label
onready var sprite2 = $Player2/Player2
onready var label2 = $Player2/Label
onready var player = $AnimationPlayer
onready var starting = $Starting

func _physics_process(delta):
	num_check()
	if !ready1:
		if Input.is_action_just_pressed("left_one"):
			num1 = num1 - 1
		elif Input.is_action_just_pressed("right_one"):
			num1 = num1 + 1
	if !ready2:
		if Input.is_action_just_pressed("left_two"):
			num2 = num2 - 1
		elif Input.is_action_just_pressed("right_two"):
			num2 = num2 + 1
	if Input.is_action_just_pressed("action1_one"):
		ready1 = true
	elif Input.is_action_just_pressed("action2_one"):
		ready1 = false
	if Input.is_action_just_pressed("action1_two"):
		ready2 = true
	elif Input.is_action_just_pressed("action2_two"):
		ready2 = false
	sprite_change()
	
	if ready1:
		ready1label.visible = true
		Character.player1 = characters[num1]
	else:
		ready1label.visible = false
		
	if ready2:
		ready2label.visible = true
		Character.player2 = characters[num2]
	else:
		ready2label.visible = false
	
	if ready1 and ready2:
		starting.visible = true
		player.play("Loading")
	else:
		starting.visible = false
		player.stop()

func num_check():
	if num1 >= total:
		var difference = num1 - total
		num1 = difference
	elif num1 < 0:
		num1 = total + num1
	if num2 >= total:
		var difference = num2 - total
		num2 = difference
	elif num2 < 0:
		num2 = total + num2

func sprite_change():
	if(num1 < total && num1 > -1):
		sprite1.play(list[num1])
		label1.text = list[num1]
	if(num2 < total && num2 > -1):
		sprite2.play(list[num2])
		label2.text = list[num2]


func changescene():
	get_tree().change_scene("res://views/FightArea.tscn")
