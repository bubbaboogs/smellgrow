extends Tile

func break_tile():
	print("Broke Dirt!")
	super.break_tile()
	
func on_right_click():
	print("Right Clicked!")
