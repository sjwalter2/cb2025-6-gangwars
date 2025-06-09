if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
{
	if (variable_instance_exists(parent, "assignedPawns") && parent.owner != noone)
	{
		if(mode == "increase")
		{
			if(parent.owner.pawns > 0)
			{
				parent.assignedPawns += 1;
				parent.owner.pawns -= 1
			}
		}
		else if(mode == "decrease")
		{
			if(parent.assignedPawns > 0)
			{
				parent.assignedPawns -= 1;
				parent.owner.pawns += 1
			}
		}
	}
}