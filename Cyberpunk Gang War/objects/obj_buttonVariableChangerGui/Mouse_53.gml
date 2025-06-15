event_inherited()


if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{
		if (variable_instance_exists(parent, variable))
		{
			if(mode == "increase")
			{
				if(variable_instance_exists(parent,"money"))
				{
					if(parent.money - cost >= 0)
					{
						parent.money = parent.money-cost;
					} else
					{
						exit;
					}
				}

				variable_instance_set(parent, variable, variable_instance_get(parent,variable)+1);
			}
			else if(mode == "decrease")
			{
				variable_instance_set(parent, variable, variable_instance_get(parent,variable)-1);
			}
		}
		global.buttonPressed = true
	}
}