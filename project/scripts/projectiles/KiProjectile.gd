extends SGKinematicBody2D

var speed = 3
var direction  := SGFixed.vector2(65536, 0)
var damage = 50
var damage_tier = 1

func _ready():
	set_as_toplevel(true)

func size(value):
	damage = damage * value
	scale.x = scale.x * value
	scale.y = scale.y * value
	if damage > 350:
		damage_tier = 4
	elif damage > 200:
		damage_tier = 3
	elif damage > 125:
		damage_tier = 2
	if damage > 500:
		damage == 500
	
func _physics_process(delta):
	var v = direction.mul(speed)
	var c := move_and_collide(v)
	if c and c.collider:
		if c.collider.has_method("hit"):
			c.collider.hit(damage)
			queue_free()
		elif c.collider.has_method("is_proj"):
			var power = c.collider.is_proj()
			if damage_tier <= power:
				queue_free()
		
func is_proj():
	return damage_tier
	
func set_target(player):
	if player == 1:
		set_collision_mask_bit(6, true)
	else:
		set_collision_mask_bit(5, true)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
