
event_inherited()

if _activated == false
	exit;

	if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
	{
		if (parent.displayStatsFull == false)
		{
			parent.displayStatsFull = true
		} else {
			parent.displayStatsFull = false
		}
		
		global.buttonPressed = true
		/*if (ds_exists(global.selected, ds_type_list)) {
			ds_list_clear(global.selected);
		}*/
	}

