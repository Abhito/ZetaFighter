extends SGArea2D

var last_overlapping_bodies: Array
export var in_attack = true
var _other_player
export var damage = 50


func _physics_process(delta):
	sync_to_physics_engine()
	
	var overlapping_bodies = get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body == _other_player and in_attack:
			body.hit(damage)
			in_attack = false

