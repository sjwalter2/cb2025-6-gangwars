event_inherited()


if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{

		with(parent)
		{
			//The button that was pressed dictates what happens in the script
			func = other.myFunction
		
			//Quest dialogue box can be closed
			displayReady = false
		}
	
		//Deactivate Quest button objects -> this also destroys them during the End Step
		with(obj_buttonQuest)
		{
			shelfActive = false;
		}

		//Unpause game after choosing an option. (Note: if pausing is not enabled, this section wont really do anything)
		with(obj_gameHandler)
		{
			nextSpeed = 1
		}
	
		global.buttonPressed = true
	}
}