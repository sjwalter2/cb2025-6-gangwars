if(distance_to_point(mouse_x,mouse_y) >150)
{
	if (buttonsActivated)
	{
		buttonsActivated = false
	}
}
else if ds_list_find_index(global.selected,self) != -1 {
	buttonsActivated = true
}