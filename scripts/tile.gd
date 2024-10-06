class_name Tile

extends Node2D

signal tile_broken
signal tile_right_clicked


func break_tile():
	emit_signal("tile_broken")
	queue_free()

# Method called when tile is right-clicked
func on_right_click():
	emit_signal("tile_right_clicked")

func _on_tile_action(action: String):
	match action:
		"break":
			break_tile()
		"right_click":
			on_right_click()
		_:
			print("Action not handled:", action)
