extends Control

var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Intro")
	yield(get_node("AnimationPlayer"), "animation_finished")
	done = true
	$AnimationPlayer.play("redeye")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done:
		if Input.is_action_just_pressed("action1_one"):
			Match.aiMode = false
			get_tree().change_scene("res://views/CharacterSelect.tscn")


func _on_playButton_pressed():
	Match.aiMode = false
	get_tree().change_scene("res://views/CharacterSelect.tscn")



func _on_aiButton_pressed():
	Match.aiMode = true
	get_tree().change_scene("res://views/CharacterSelect.tscn")
