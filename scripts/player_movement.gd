extends CharacterBody2D

@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = Input.get_axis("walk_left", "walk_right") * speed
	
	move_and_slide()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
