extends ProgressBar

var shake_amount = 1.0

export var shake_power = 4
export var shake_time = 0.4
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
	randomize()
	curPos = rect_position

func _process(delta):
	if isShake:
		shake(delta)    

func makeShake():
	elapsedtime = 0
	isShake = true

func shake(delta):
	if elapsedtime<shake_time:
		rect_position =  curPos + (Vector2(randf(), randf()) * shake_power)
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		rect_position = curPos 
