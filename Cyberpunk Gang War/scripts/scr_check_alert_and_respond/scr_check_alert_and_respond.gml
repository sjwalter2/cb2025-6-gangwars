function scr_check_alert_and_respond(gangster) {
    if (gangster.state == "intervening" || gangster.alert_responding || !gangster.alert_active || gangster.alert_tile_index == -1) return false;

    var my_axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var start_q = my_axial.q;
    var start_r = my_axial.r;

    var target_tile = global.hex_grid[gangster.alert_tile_index];

    // Validate target tile
    if (target_tile == undefined) {
        gangster.alert_active = false;
        gangster.alert_tile_index = -1;
        return false;
    }

    var path = scr_hex_a_star_path(start_q, start_r, target_tile.q, target_tile.r, gangster.owner.name, true);
    if (!is_array(path) || array_length(path) == 0) {
        gangster.alert_active = false;
        gangster.alert_tile_index = -1;
        return false;
    }

    // Evaluate path cost like AI does
    var total_cost = 0;
    for (var i = 0; i < array_length(path); i++) {
        var step_tile = global.hex_grid[path[i]];
        if (step_tile.owner == gangster.owner.name) {
            total_cost += global.cost_friendly;
        } else if (step_tile.owner == "") {
            total_cost += global.cost_unclaimed;
        } else {
            total_cost += global.cost_enemy;
        }
    }

    // If someone is already capturing this tile, compare timing
    var found_capture = false;
    var cap_ticks_remaining = 0;
    with (obj_gangster) {
        if (state == "capturing" && capture_tile_index == gangster.alert_tile_index) {
            found_capture = true;
            cap_ticks_remaining = capture_ticks_remaining;
        }
    }

    // Either no one is capturing yet, or we can make it in time
    var can_help = (!found_capture || total_cost <= cap_ticks_remaining);

    if (can_help) {
        gangster.move_path = path;
        gangster.has_followup_move = true;
        gangster.target_tile_index = gangster.alert_tile_index; // Matches AI target usage

        var first_step = array_shift(gangster.move_path);
        scr_gangster_start_movement(gangster, first_step, true, true);
        scr_clear_gang_alerts(gangster.owner.name, id);
        gangster.alert_responding = true;
		// ✅ Add these to match AI movement
	    if (gangster.move_target != undefined) {
	        gangster.move_queued = true;
	        gangster.state = "waiting";
	    } else {
	        gangster.state = "idle";
	        gangster.move_queued = false;
	    }
        return true;
    }

    // Alert target not viable — abandon it
    gangster.alert_active = false;
    gangster.alert_tile_index = -1;
    return false;
}
