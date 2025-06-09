if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
{
	if (variable_instance_exists(parent, variable))
	{
		if(mode == "increase")
		{
			variable_instance_set(parent, variable, variable_instance_get(parent,variable)+1);
		}
		else if(mode == "decrease")
		{
			variable_instance_set(parent, variable, variable_instance_get(parent,variable)-1);
		}
	}
}