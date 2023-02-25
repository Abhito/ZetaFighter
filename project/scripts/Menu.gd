extends Control


var done = false

func _ready():
	yield(ParticlesCache, "particles_loaded")
	$AnimationPlayer.play("Intro")
	yield(get_node("AnimationPlayer"), "animation_finished")
	done = true
	$AnimationPlayer.play("redeye")


func _process(delta):
	if done:
		if Input.is_action_just_pressed("player1_attack"):
			Match.aiMode = false
			goSelect()
		elif Input.is_action_just_pressed("player1_defend"):
			Match.aiMode = true
			goSelect()


func _on_playButton_pressed():
	Match.aiMode = false
	goSelect()



func _on_aiButton_pressed():
	Match.aiMode = true
	goSelect()

func goSelect():
	SceneChanger.goto_scene("res://views/CharacterSelect.tscn", self)
