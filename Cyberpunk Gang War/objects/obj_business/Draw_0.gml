draw_self()

if (ds_list_find_index(global.selected,self) != -1) {
	draw_circle(x+0.5*sprite_width,y+0.5*sprite_height,30,true)	
}