
//If dialogue box is active, do funny stuff
if(displayReady)
{
	display_outer_rect += display_outer_rect_direction
	if(display_outer_rect < 0 || display_outer_rect > 20)
	{
		display_outer_rect_direction = display_outer_rect_direction*-1
	}
}
if(is_method(myQuest))
{
	if(func != "setup")
	{
		//If quest is activated, execute whatever script is associated with this quest
		myQuest(func)
	}
}
