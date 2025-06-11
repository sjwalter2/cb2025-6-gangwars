// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_select_object(){
	if mouse_x > x && mouse_y > y && mouse_x < x+sprite_get_width(sprite_index) && mouse_y < y+sprite_get_height(sprite_index)
	{
		buttonsActivated = true
		if(ds_list_find_index(global.selected,self) == -1)
		{
			ds_list_add(global.selected,self)
		}
	} else {
		var _i = ds_list_find_index(global.selected,self)
		if (_i != -1)
		{
			ds_list_delete(global.selected,_i)
			buttonsActivated = false
		}
	}
}