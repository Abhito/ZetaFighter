extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Intro")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$AnimationPlayer.play("redeye")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_playButton_pressed():
	get_tree().change_scene("res://views/CharacterSelect.tscn")


func _on_settingButton_pressed():
	get_tree().change_scene("res://views/Settings.tscn")
