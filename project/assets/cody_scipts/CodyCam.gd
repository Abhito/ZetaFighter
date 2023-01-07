extends Camera2D

export var shake_power = 8
export var shake_time = 0.15
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
	randomize()
	curPos = position

func _process(delta):
	if isShake:
		shake(delta)

func makeShake():
	elapsedtime = 0
	isShake = true

func shake(delta):
	if elapsedtime<shake_time:
		position =  curPos + (Vector2(randf(), randf()) * shake_power)
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		position = curPos 
