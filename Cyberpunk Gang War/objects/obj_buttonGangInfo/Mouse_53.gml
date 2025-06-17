event_inherited()

if shelfActive
{
	if (device_mouse_x_to_gui(0) > guiX && device_mouse_x_to_gui(0) < guiX+sprite_width && device_mouse_y_to_gui(0) > guiY && device_mouse_y_to_gui(0) < guiY+sprite_height) 
	{
		var pawnsIncrease = instance_create_depth(x,y,0,obj_buttonHirePawnGui)
		with pawnsIncrease
		{
			parent=other.gang
			cost = 10
			text = other.gang.name + " Hire Pawn: $" + string(cost)
		}
		with obj_gui_button_shelf {
			createShelf([pawnsIncrease])
		}
		global.buttonPressed = true
	}
}
