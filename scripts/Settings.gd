extends Control

var player1 = false
var player2 = false
var shrink = false

onready var player1box = $TabContainer/Controls/CenterContainer/Items/controller/EnableController/player1
onready var player2box = $TabContainer/Controls/CenterContainer/Items/controller/EnableController/player2
onready var shrinkKey = $TabContainer/Controls/CenterContainer/Items/KeyBoardControls/shrink


func _on_CheckBox_pressed():
	if player1:
		player1 = false
	else:
		player1 = true


func _on_player2_pressed():
	if player2:
		player2 = false
	else:
		player2 = true


func _on_shrink_pressed():
	if shrink:
		shrink = false
		clear_shrink()
	else:
		shrink = true
		shrink()

func shrink():
	var event = InputEventKey.new()
	event.scancode = KEY_C
	InputMap.action_add_event("action1_one", event)
	event.scancode = KEY_V
	InputMap.action_add_event("action2_one", event)
	event.scancode = KEY_PERIOD
	InputMap.action_add_event("action1_two", event)
	event.scancode = KEY_SLASH
	InputMap.action_add_event("action2_two", event)

func clear_shrink():
	var event = InputEventKey.new()
	event.scancode = KEY_C
	InputMap.action_erase_event("action1_one", event)
	event.scancode = KEY_V
	InputMap.action_erase_event("action2_one", event)
	event.scancode = KEY_PERIOD
	InputMap.action_erase_event("action1_two", event)
	event.scancode = KEY_SLASH
	InputMap.action_erase_event("action2_two", event)
	
func add_controller_to_one():
	var event = InputEventJoypadButton.new()
