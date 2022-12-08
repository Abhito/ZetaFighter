extends KinematicBody2D

var speed = 350
var direction  := Vector2.RIGHT
var damage = 500
var damage_tier = 5
var on_screen = true
var timer = false

func _ready():
	set_as_toplevel(true)
	direction = direction.normalized()

func size(value):
	pass
	
func direct(position):
	direction = (position - self.global_position).normalized()
	$Timer.start()
	
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
	if !on_screen and timer:
		queue_free()
		
func is_proj():
	return damage_tier


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("Ground"):
		queue_free()


func _on_Timer_timeout():
	timer = true
