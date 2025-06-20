event_inherited()


if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{
		if (variable_instance_exists(parent, "pawns"))
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

				parent.pawns += 1;
				parent.freePawns += 1;
			}
			else if(mode == "decrease")
			{
				if(parent.pawns > 0 && parent.freePawns > 0)
				{
					parent.pawns -= 1;
					parent.freePawns -= 1;
				}
			}
		}
		global.buttonPressed = true
		
	effect_create_layer("UI", ef_star,device_mouse_x_to_gui(0),device_mouse_y_to_gui(0), 2, c_yellow);
	}
}