if(global.inputLocked) exit;
var _stringArray = []

if(distance_to_point(mouse_x,mouse_y) < 10 || (ds_list_find_index(global.selected,self) != -1)) {
	array_push(_stringArray,"Assigned Pawns: " + string(assignedPawns) + "/" + string(maxPawns))
	if(manager != noone)
	{
		array_push(_stringArray,"Manager: " + string(manager.name));
	}
	if(owner != noone)
	{
		array_push(_stringArray,"Owner: " + string(owner.name));
	}
	
	array_push(_stringArray,"Base income: " + string(baseIncome));
	if(adjustedIncome != baseIncome)
	{
		array_push(_stringArray,"Adjusted Income: " + string(adjustedIncome));
	}
	array_push(_stringArray,name);
	scr_draw_tooltip_ext(_stringArray,x,y)
}
