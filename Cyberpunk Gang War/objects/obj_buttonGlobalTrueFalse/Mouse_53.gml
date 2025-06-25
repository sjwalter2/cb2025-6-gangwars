event_inherited()

if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
{
	if (variable_global_exists(variable))
	{
		var newVar = !variable_global_get(variable)
		show_debug_message("old: " + string(variable_global_get(variable)) + ", new: " + string(newVar))
		variable_global_set(variable,newVar)
	}
	global.buttonPressed = true
}