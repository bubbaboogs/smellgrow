class_name Tile

extends Node2D

# Signals for custom actions
signal tile_broken
signal tile_right_clicked

# Method called when tile is broken
func break_tile():
	emit_signal("tile_broken")
	# Default behavior (can be overridden)
	queue_free()  # Remove tile after breaking

# Method called when tile is right-clicked
func on_right_click():
	emit_signal("tile_right_clicked")
	# Default behavior (can be overridden)

# Method to add any tile-specific functionality
func _on_tile_action(action: String):
	match action:
		"break":
			break_tile()
		"right_click":
			on_right_click()
		_:
			print("Action not handled:", action)
