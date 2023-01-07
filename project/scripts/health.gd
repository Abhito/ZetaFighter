extends ProgressBar

onready var energy_bar = $Energy
export var shake_power = 4
export var shake_time = 0.4
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
	randomize()
	energy_bar.value = 0
	curPos = rect_position

func _process(delta):
	if isShake:
		shake(delta)
	if energy_bar.value >= energy_bar.max_value:
		energy_bar.modulate = Color8(500,500,500)
	else:
		energy_bar.modulate = Color8(255,255,255) 

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
