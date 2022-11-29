extends Control

var list = ["Random", "Lucy", "Cody", "Zeta Hero", "Epsilon"]
var characters = ["res://assets/girlFighter.tscn", "res://assets/girlFighter.tscn", "res://assets/cody.tscn", "res://assets/heroFighter.tscn", "res://assets/zetaFighter.tscn"]

var stageList = ["Random Stage", "Cyber City", "Cyber Miami", "Cyber City - West Side", "Underground Factory"]
var stages = ["res://assets/Backgrounds/CyberCity.tscn", "res://assets/Backgrounds/CyberCity.tscn", "res://assets/Backgrounds/CyberMiami.tscn", "res://assets/Backgrounds/CyberStreets.tscn", "res://assets/Backgrounds/BulkHead.tscn"]
var numStage = 0
var stageTotal = 5
var stageready = false
var lastPlayer = 0

var num1 = 0
var num2 = 0
var total = 5
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
onready var glow = $TextureRect/AnimationPlayer

onready var player1arrows = $Player1/Arrows
onready var player2arrows = $Player2/Arrows
onready var stagearrows = $StageSelect/Arrows

onready var stageSprite = $StageSelect/Panel/StageSprite
onready var stageLabel = $StageSelect/Label

var rng = RandomNumberGenerator.new()

func _ready():
	if Match.aiMode:
		ready2 = true
	glow.play("glow")
	$Glower.play("arrow_glow")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://views/Menu.tscn")
	num_check()
	stage_change()
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
	
	if !(ready1 and ready2):
		stagearrows.visible = false
		if Input.is_action_just_pressed("action1_one"):
			ready1 = true
			lastPlayer = 1
			if ready2 and not Match.aiMode:
				$labelMover.play("Player2")
			elif Match.aiMode:
				lastPlayer = 2
				$labelMover.play("Player1")
		elif Input.is_action_just_pressed("action2_one"):
			ready1 = false
		if not Match.aiMode: #If not in AI mode than player two can set
			if Input.is_action_just_pressed("action1_two"):
				ready2 = true
				lastPlayer = 2
				if ready1:
					$labelMover.play("Player1")
			elif Input.is_action_just_pressed("action2_two"):
				ready2 = false
	sprite_change()
	
	if ready1:
		player1arrows.visible = false
		ready1label.visible = true
		var num = num1
		if num == 0:
			num = rng.randi_range(1, total - 1)
		Match.player1 = characters[num]
		Match.name1 = list[num]
	else:
		player1arrows.visible = true
		ready1label.visible = false
		
	if ready2:
		player2arrows.visible = false
		ready2label.visible = true
		var num = num2
		if num == 0:
			num = rng.randi_range(1, total - 1)
		Match.player2 = characters[num]
		if Match.aiMode:
			if num > 1:
				Match.aiMelee = true
			else:
				Match.aiMelee = false
			Match.name2 = "AI - " + list[num]
		else:
			Match.name2 = list[num]
	else:
		player2arrows.visible = true
		ready2label.visible = false
	
	if stageready:
		var num = numStage
		if numStage == 0:
			num = rng.randi_range(1, stageTotal - 1)
		stagearrows.visible = false
		Match.stage = stages[num]
		starting.visible = true
		player.play("Loading")
	else:
		starting.visible = false
		player.stop()

func stage_change():
	if ready1 and ready2 and !stageready:
		stagearrows.visible = true
		if lastPlayer == 2:
			if Input.is_action_just_pressed("left_one"):
				numStage = numStage - 1
			elif Input.is_action_just_pressed("right_one"):
				numStage = numStage + 1
			if Input.is_action_just_pressed("action1_one"):
				stageready = true
			if !stageready:
				if Input.is_action_just_pressed("action2_one"):
					$labelMover.play("Player1_not")
					ready1 = false
		else:
			if Input.is_action_just_pressed("left_two"):
				numStage = numStage - 1
			elif Input.is_action_just_pressed("right_two"):
				numStage = numStage + 1
			if Input.is_action_just_pressed("action1_two"):
				stageready = true
			if !stageready:
				if Input.is_action_just_pressed("action2_two"):
					$labelMover.play("Player2_not")
					ready2 = false
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
	if numStage >= stageTotal:
		var difference = numStage - stageTotal
		numStage = difference
	elif numStage < 0:
		numStage = stageTotal + numStage

func sprite_change():
	if(num1 < total && num1 > -1):
		sprite1.play(list[num1])
		label1.text = list[num1]
	if(num2 < total && num2 > -1):
		sprite2.play(list[num2])
		label2.text = list[num2]
	if(numStage < stageTotal && numStage > -1):
		stageSprite.play(stageList[numStage])
		stageLabel.text = stageList[numStage]


func changescene():
	get_tree().change_scene("res://views/FightArea.tscn")
