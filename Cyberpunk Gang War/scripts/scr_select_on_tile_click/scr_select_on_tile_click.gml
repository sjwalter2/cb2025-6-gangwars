/// @function scr_select_on_tile_click()
/// @desc Selects highest-priority object on the clicked tile, cycling if clicked again

function scr_select_on_tile_click() {
	if (global.selection_cooldown) exit;

	var pixel_x = mouse_x - global.offsetX;
	var pixel_y = mouse_y - global.offsetY;
	var click_axial = scr_pixel_to_axial(pixel_x, pixel_y);
	var objects_on_tile = [];

	// === Priority 1: Gangsters
	with (obj_gangster) {
		var self_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
			if (self_axial.q == click_axial.q && self_axial.r == click_axial.r && !is_moving && !move_queued) {
			    array_push(objects_on_tile, { inst: id, priority: 1 });
			}
	}

	// === Priority 2: Strongholds
	with (obj_stronghold) {
		if (q == click_axial.q && r == click_axial.r) {
			array_push(objects_on_tile, { inst: id, priority: 2 });
		}
	}

	if (array_length(objects_on_tile) == 0) {
		ds_list_clear(global.selected);
		buttonsActivated = false;
		exit;
	}

	// Sort by priority (lowest number is highest priority)
	for (var i = 0; i < array_length(objects_on_tile) - 1; i++) {
	    for (var j = 0; j < array_length(objects_on_tile) - i - 1; j++) {
	        if (objects_on_tile[j].priority > objects_on_tile[j + 1].priority) {
	            var temp = objects_on_tile[j];
	            objects_on_tile[j] = objects_on_tile[j + 1];
	            objects_on_tile[j + 1] = temp;
	        }
	    }
	}

	// Cycle if re-clicking
	var current_selection = (ds_list_size(global.selected) > 0) ? global.selected[| 0] : noone;
	var current_index = -1;

	for (var i = 0; i < array_length(objects_on_tile); i++) {
		if (objects_on_tile[i].inst == current_selection) {
			current_index = i;
			break;
		}
	}

	var next_index = (current_index + 1) mod array_length(objects_on_tile);
	var next_selection = objects_on_tile[next_index].inst;

	ds_list_clear(global.selected);
	ds_list_add(global.selected, next_selection);
	buttonsActivated = true;
}
