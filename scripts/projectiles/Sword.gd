extends KinematicBody2D

var speed = 5
var player = 0
var damage_tier = 4
var direction  := 0
var velocity := Vector2.ZERO
var damage = 200
var gravity = .2
var exit = false #Exit is for when the sword is forced out
var is_powered = false
var is_grounded = false
onready var sword = get_node("Sword")
onready var animation_player = $AnimationPlayer

func _ready():
	if exit:
		$Timer.start()
		is_powered = false
	scale.x = scale.x * 1.5
	scale.y = scale.y * 1.5
	animation_player.play("Spin")
	set_as_toplevel(true)

func setup(value, player):
	gravity = value
	self.player = player
	
func leave(player):
	self.player = player
	exit = true
	
func _physics_process(delta):
	if player == 2:
		sword.modulate = Color8(150,150,255)
	if !exit:
		velocity.x = direction * speed
		velocity.y += gravity * delta
		var c := move_and_collide(velocity)
		if c and c.collider:
			if c.collider.has_method("hit"):
				c.collider.hit(damage)
				hit_ground()
			elif c.collider.has_method("hit_ground"):
				hit_ground()
				c.collider.hit_ground()
			elif c.collider.has_method("is_proj"):
				var power = c.collider.is_proj()
				if damage_tier <= power:
					hit_ground()
			elif c.collider.is_in_group("Ground"):
				hit_ground()
			else:
				hit_ground()
	else:
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)
		if !$Timer.is_stopped():
			velocity.y -= 10 * delta
		else:
			velocity.y += 50 * delta
		velocity.x = direction * speed
		var c := move_and_collide(velocity)
		if c and c.collider:
			if c.collider.has_method("hit"):
				c.collider.hit(damage)
				hit_ground()
			elif c.collider.has_method("hit_ground"):
				hit_ground()
				c.collider.hit_ground()
			elif c.collider.has_method("is_proj"):
				var power = c.collider.is_proj()
				if damage_tier <= power:
					hit_ground()
			elif c.collider.is_in_group("Ground"):
				hit_ground()
			else:
				hit_ground()

func hit_ground():
	if !is_grounded:
		velocity.y += 5
		set_collision_layer_bit(2, false)
		set_collision_layer_bit(3, true)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)
		animation_player.play("Ground")
		speed = 0
		is_grounded = true

func is_proj():
	return damage_tier
	
func sword_found():
	queue_free()

func powered():
	is_powered = true
