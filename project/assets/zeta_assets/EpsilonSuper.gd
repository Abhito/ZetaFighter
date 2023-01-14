extends Node2D

var speed = 400
var direction  := Vector2.RIGHT
var damage = 400
var damage_tier = 5
var my_owner
var enemy
var on_screen = true
onready var blast: KinematicBody2D = $SuperStart/EndPosition/SuperEnd
onready var path = $SuperStart/EndPosition/Path

func _ready():
	set_as_toplevel(true)
	direction = direction.normalized()
	look_at(direction + global_position)
	blast.add_collision_exception_with(my_owner)
	$Timer.start()

func direct(position):
	direction = (position - self.global_position).normalized()
	
func avoid(body: KinematicBody2D):
	my_owner = body
	
func _physics_process(delta):
	if not on_screen and $SuperTime.is_stopped():
		$SuperTime.start()
	var v = direction * speed * delta
	path.scale.x += 200 * delta
	var c := blast.move_and_collide(v)
	if c and c.collider:
		if c.collider.has_method("hit"):
			c.collider.hit(damage)
			my_owner.super_done()
			queue_free()
		elif c.collider.has_method("is_proj"):
			var power = c.collider.is_proj()
			if damage_tier <= power:
				my_owner.super_done()
				queue_free()
		elif c.collider.is_in_group("Ground"):
			my_owner.super_done()
			queue_free()
		
func is_proj():
	return damage_tier


func _on_Timer_timeout():
	blast.visible = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_SuperTime_timeout():
	if not on_screen:
		my_owner.super_done()
		queue_free()


func _on_PathHurtBox_body_entered(body):
	$Damager.start()
	body.hit(50)
	enemy = body


func _on_Damager_timeout():
	enemy.hit(50)
