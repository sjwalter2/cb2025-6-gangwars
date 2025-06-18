/// scr_tick_gangster_moving(gangster)
function scr_tick_gangster_moving(gangster) {
    gangster.flash_timer = current_time + 150;
    gangster.flash_type = "move";

    var t = gangster.move_ticks_elapsed / gangster.move_total_ticks;
    if (!is_struct(gangster.move_target) || !variable_struct_exists(gangster.move_target, "start_pos") || !variable_struct_exists(gangster.move_target, "target_pos")) return;
    var start = gangster.move_target.start_pos;
    var target = gangster.move_target.target_pos;

    gangster.x = lerp(start.x, target.x, t);
    gangster.y = lerp(start.y, target.y, t);

    gangster.move_ticks_elapsed++;
    gangster.first_tick_bonus = 0;

    if (gangster.move_ticks_elapsed >= gangster.move_total_ticks) {
        gangster.x = target.x;
        gangster.y = target.y;

        var idx = ds_list_find_index(global.claimed_tile_indices, gangster.move_target.tile_index);
        if (idx != -1) ds_list_delete(global.claimed_tile_indices, idx);

        gangster.is_moving = false;
        gangster.move_target = undefined;
        gangster.move_ticks_elapsed = 0;
        gangster.move_total_ticks = 0;

        gangster.flash_timer = current_time + 300;
        gangster.flash_type = "arrive";

        if (gangster.has_followup_move && array_length(gangster.move_path) > 0) {
            var next_tile_index = array_shift(gangster.move_path);
            if (array_length(gangster.move_path) == 0) gangster.has_followup_move = false;

            var next_tile = global.hex_grid[next_tile_index];
            var next_key = scr_axial_key(next_tile.q, next_tile.r);

            if (ds_map_exists(global.gangster_tile_map, next_key)) {
                gangster.state = "idle";
                gangster.move_path = [];
                gangster.has_followup_move = false;
                gangster.reserved_stronghold_key = undefined;
            } else {
                scr_gangster_start_movement(gangster, next_tile_index, false);
            }
        } else {
			// Transition from moving_alerted to alerted
			if (gangster.state == "moving_alerted") {
			    if (is_array(gangster.alert_path) && array_length(gangster.alert_path) > 0) {
			        gangster.path = gangster.alert_path;
			        gangster.move_path = gangster.alert_path;
			        gangster.target_tile_index = gangster.alert_target_tile_index;
			        gangster.path_progress = 0;
			        gangster.move_elapsed = 0;
					gangster.is_intervening_path = true;
			        gangster.state = "moving";

			        scr_gangster_start_movement(gangster, array_shift(gangster.alert_path), false);
			        return;
			    }
			}

            var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
            var key = scr_axial_key(axial.q, axial.r);

            if (!ds_map_exists(global.hex_lookup, key)) return;

            var final_tile_index = global.hex_lookup[? key];
            var tile = global.hex_grid[final_tile_index];

            if (is_intervening_path == true) {
                gangster.state = "intervening";
				is_intervening_path = false;
                return;
            }

            if (tile.owner != gangster.owner.name) {
                gangster.state = "capturing";

                var move_cost = global.cost_unclaimed;
                if (!is_undefined(tile.owner)) move_cost = global.cost_enemy;
                if (tile.type == "stronghold") move_cost *= 2;

                gangster.capture_ticks_remaining = move_cost * 2;
                gangster.capture_tile_index = final_tile_index;

                scr_alert_closest_defender(gangster, gangster.capture_tile_index);

                var tile_ref = global.hex_grid[gangster.capture_tile_index];
                tile_ref.flicker_enabled = true;
                tile_ref.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
                tile_ref.flicker_next = current_time + 1000;
                tile_ref.flicker_on = false;
                tile_ref.pending_color = scr_get_gang_color(gangster.owner.name);
                tile_ref.pending_owner = gangster.owner.name;
                global.hex_grid[gangster.capture_tile_index] = tile_ref;
            } else {
                gangster.state = (gangster.captures_since_resupply >= global.resupply_tile_limit) ? "resupplying" : "idle";
            }
        }
    }
}