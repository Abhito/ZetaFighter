extends KinematicBody2D

const UP_Direction := Vector2.UP

export var speed := 600.0

export var jump_strength := 1500.0
export var maximum_jumps := 2
export var double_jump_strength := 1200.0
export var gravity := 4500.0

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var _pivot: Node2D = $"."
onready var _animation_sprite: AnimatedSprite = $AnimatedSprite
onready var _start_scale: Vector2 = _pivot.scale

func _physics_process(delta: float) -> void:
		var _horizontal_direction = 0
		if Input.is_action_pressed("right_one"):
			_horizontal_direction += 1
		if Input.is_action_pressed("left_one"):
			_horizontal_direction -= 1
		
		_velocity.x = _horizontal_direction * speed
		_velocity.y += gravity * delta
		
		#Add animation code here
		var is_falling := _velocity.y > 0.0 and not is_on_floor()
		var is_jumping := Input.is_action_just_pressed("up_one") and is_on_floor()
		var is_double_jumping := Input.is_action_just_pressed("up_one") and is_falling
		var is_jump_cancelled := Input.is_action_just_pressed("up_one") and _velocity.y < 0.0
		var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
		var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
		
		if is_jumping:
			_jump_made += 1
			_velocity.y = -jump_strength
		elif is_double_jumping:
			_jump_made += 1
			if _jump_made <= maximum_jumps:
				_velocity.y = -double_jump_strength
		elif is_jump_cancelled:
			_velocity.y = 0.0
		elif is_idling or is_running:
			_jump_made = 0
		
		_velocity = move_and_slide(_velocity, UP_Direction)
			
		if is_jumping or is_double_jumping:
			_animation_sprite.play("jump")
		elif is_running:
			_animation_sprite.play("walk")
		elif is_falling:
			_animation_sprite.play("Fall")
		elif is_idling:
			_animation_sprite.play("Idle")
