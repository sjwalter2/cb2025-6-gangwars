
event_inherited()
if _activated == false
	exit;

	if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
	{
		if (global.displayStatsFull == false)
		{
			global.displayStatsFull = true
		} else {
			global.displayStatsFull = false
		}
		global.buttonPressed = true
	}

