/*if(parent != noone) {
	if(ds_list_find_index(global.selected, parent) != -1) {
		show_debug_message("selected!")
		draw_self()	
	}
} else {
	draw_self()
}*/



if (ds_exists(global.selected, ds_type_list)) {
    for (var i = 0; i < ds_list_size(global.selected); i++) {
        var inst = global.selected[| i];
        if (instance_exists(inst) && variable_instance_exists(inst, "name") && instance_exists(parent)) {
            if inst.name == parent.name {
				draw_sprite_ext(sprite_index,0,x,y,0.5,0.5,1,c_white,1)
			}
		}
	}
}