/// @description Assigns or unassigns pawns to a business or stronghold
event_inherited()

if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
{
	if (variable_instance_exists(parent, "assignedPawns") && parent.owner != noone)
	{
		if(mode == "increase")
		{
			if(parent.owner.freePawns > 0)
			{
				parent.assignedPawns += 1;
				parent.owner.freePawns -= 1
			}
		}
		else if(mode == "decrease")
		{
			if(parent.assignedPawns > 0)
			{
				parent.assignedPawns -= 1;
				parent.owner.freePawns += 1
			}
		}
	}
	global.buttonPressed = true
}