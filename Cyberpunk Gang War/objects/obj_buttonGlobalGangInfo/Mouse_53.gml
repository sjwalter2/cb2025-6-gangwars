
event_inherited()

if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{
		if (global.displayGangStatsFull == false)
		{
			global.displayGangStatsFull = true
		} else {
			global.displayGangStatsFull = false
		}
		global.buttonPressed = true
	}
}
