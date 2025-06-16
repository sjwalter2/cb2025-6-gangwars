draw_self()
if(distance_to_point(mouse_x,mouse_y) < 100 || (ds_list_find_index(global.selected,self) != -1)) {
	draw_text(x,y+60,"Assigned Pawns: " + string(assignedPawns))
	if(manager != noone)
		draw_text(x,y+80,"Manager: " + string(manager.name))
	if(owner != noone)
		draw_text(x,y+100,"Owner: " + string(owner.name))
	draw_text(x,y+120,"Base income: " + string(baseIncome))
	draw_text(x,y+140,"Adjusted Income: " + string(adjustedIncome))
}

if (ds_list_find_index(global.selected,self) != -1) {
	draw_circle(x+0.5*sprite_width,y+0.5*sprite_height,30,true)	
}