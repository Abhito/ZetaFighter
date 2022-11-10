extends KinematicBody2D

var speed = 350
var direction  := Vector2.RIGHT
var damage = 50

func _ready():
	set_as_toplevel(true)
	direction = direction.normalized()
	look_at(direction + global_position)

func size(value):
	damage = damage * value
	scale.x = scale.x * value
	scale.y = scale.y * value
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c := move_and_collide(v)
	if c and c.collider:
		if c.collider.has_method("hit"):
			c.collider.hit(damage)
		queue_free()
