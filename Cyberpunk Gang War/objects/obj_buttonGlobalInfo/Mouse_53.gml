
event_inherited()
//if _activated == false
//	exit;

if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{
		if (global.displayStatsFull == false)
		{
			global.displayStatsFull = true
		} else {
			global.displayStatsFull = false
			with(obj_gangster) {
				displayStatsFull = false
			}
		}
		global.buttonPressed = true
	}
}
