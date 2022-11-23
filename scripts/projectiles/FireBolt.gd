extends KinematicBody2D

var speed = 200
var direction  := Vector2.RIGHT
var damage = 30
var damage_tier = 0

func _ready():
	set_as_toplevel(true)
	direction = direction.normalized()
	look_at(direction + global_position)

func size(value):
	scale.x = scale.x * -1
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c := move_and_collide(v)
	if c and c.collider:
		if c.collider.has_method("hit"):
			c.collider.hit(damage)
			queue_free()
		elif c.collider.has_method("is_proj"):
			var power = c.collider.is_proj()
			if damage_tier <= power:
				queue_free()
		else:
			queue_free()
		
func is_proj():
	return 0
