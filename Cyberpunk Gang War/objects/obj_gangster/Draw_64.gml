

if(distance_to_point(mouse_x,mouse_y) < 100 || (ds_list_find_index(global.selected,self) != -1)) {
	draw_text(x+40,y,name)
	draw_text(x+40,y+20,"Cash: " + string(money))
}

if (ds_list_find_index(global.selected,self) != -1) {
	draw_circle(x+0.5*sprite_width,y+0.5*sprite_height,30,true)	
	if(displayStatsFull){
		draw_text(x+40,y+40,"Charisma: " + string(charisma))
		draw_text(x+40,y+60,"Might: " + string(might))
		draw_text(x+40,y+80,"Honor: " + string(honor))
	}
}