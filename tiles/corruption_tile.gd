extends Tile

func break_tile():
	print("Broke Stone!")
	super.break_tile()
	
func on_right_click():
	pass
	
func _enter_tree() -> void:
	var timer = Timer.new()
	timer.autostart = true
	add_child(timer)
	timer.wait_time = 1
	timer.start(1)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var tilemap: TileMapLayer = get_parent()
	var location = tilemap.local_to_map(self.position)
	tilemap.set_cell(Vector2(location.x - 1, location.y), 0, Vector2.ZERO, 3)
	tilemap.set_cell(Vector2(location.x + 1, location.y), 0, Vector2.ZERO, 3)
	tilemap.set_cell(Vector2(location.x, location.y - 1), 0, Vector2.ZERO, 3)
	tilemap.set_cell(Vector2(location.x, location.y + 1), 0, Vector2.ZERO, 3)
