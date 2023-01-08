extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export var max_load_time = 5000

func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("Resource loader unable to load the resource at path")
		return
		
	var loading_bar = load("res://views/LoadingBar.tscn").instance()
	
	get_tree().get_root().call_deferred('add_child', loading_bar)
	
	var t = OS.get_ticks_msec()
	current_scene.queue_free()
	while OS.get_ticks_msec() - t < max_load_time:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#Loading Complete
			var resource = loader.get_resource()
			get_tree().current_scene = resource.instance()
			get_tree().get_root().call_deferred('add_child', resource.instance())
			loading_bar.queue_free()
			break
		elif err == OK:
			#Still loading
			var progress = float(loader.get_stage())/loader.get_stage_count()
		else:
			print("Error while loading file")
			break
		yield(get_tree(), "idle_frame")
