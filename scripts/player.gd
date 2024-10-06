extends CharacterBody2D

@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25
const TILE_SIZE = 16
@export var reach = 100

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	move_and_slide()
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
		
func interact_with_tile(tile: Node, action: String):
	if tile.has_method("_on_tile_action"):
		tile._on_tile_action(action)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("break"):
		var tile = get_tile_at_mouse()
		if tile:
			interact_with_tile(tile, "break")
	elif event.is_action_pressed("right_click"):
		var tile = get_tile_at_mouse()
		if tile:
			interact_with_tile(tile, "right_click")
			
func get_tile_at_mouse() -> Node:
	var mouse_pos = get_global_mouse_position()
	var tiles = get_tree().get_nodes_in_group("tiles").filter(
		func(node):
			var tile_distance = node.global_position.distance_to(global_position)
			return tile_distance <= reach and node.global_position.distance_to(mouse_pos) < (TILE_SIZE * 1.4)
	)

	if tiles.size() > 0:
		return tiles[0]
	else:
		return null
