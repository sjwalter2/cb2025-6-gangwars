if (!global.inputLocked && mouse_check_button_pressed(mb_left)) {
	if (instance_exists(obj_map)) { // Make sure the map exists
		var click_axial = scr_pixel_to_axial(mouse_x - global.offsetX, mouse_y - global.offsetY);

		var move_attempted = false;

		if global.buttonPressed == false
		{
			// If gangster is selected, try to move
			if (ds_list_size(global.selected) > 0) {
				var inst = global.selected[| 0];
				if (instance_exists(inst) && inst.object_index == obj_gangster) {
					//move_attempted = scr_try_gangster_move_or_select(click_axial.q, click_axial.r);
				}
			}

			// Only change selection if movement wasn't attempted (click was not valid move target)
			if (!move_attempted) {
				scr_select_on_tile_click();	
			}
		}
	}
}
