
event_inherited()

if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
{
	var _newSpeed = 0
	switch(global.currentSpeed)
	{
		case 0:
			_newSpeed = 1
			break;
		case 1:
			_newSpeed = 2
			break;
		case 2:
			_newSpeed = 0
			break;
		default:
			_newSpeed = 0
			break;
	}
	with(obj_gameHandler)
	{
		nextSpeed = _newSpeed
	}
	
	
	global.buttonPressed = true
}
