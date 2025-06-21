/// @function scr_tick_gangster_resupplying(gangster)
/// @desc Attempts to reach a friendly stronghold and resupply. If blocked by enemy, switches to alerted state.
/// @returns N/A

function scr_tick_gangster_resupplying(gangster) {
    // Retry finding a stronghold if needed
	if(stuck_waiting >3)
		var k = 1;
    if (!is_array(gangster.move_path) || array_length(gangster.move_path) == 0) {
        gangster.reserved_stronghold_key = scr_find_closest_stronghold(gangster.owner.name, gangster.x, gangster.y, true);
    }

    if (gangster.reserved_stronghold_key == undefined) return;

    var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var sx = floor(gangster.reserved_stronghold_key / 10000) - 5000;
    var sy = gangster.reserved_stronghold_key mod 10000 - 5000;
    var dist = scr_axial_distance(axial.q, axial.r, sx, sy);

    var occupied = false;
	var stronghold_key = scr_axial_key(sx, sy);
	if (ds_map_exists(global.gangster_tile_map, stronghold_key)) {
		var blocker = ds_map_find_value(global.gangster_tile_map, stronghold_key);
		if (blocker != gangster.id && instance_exists(blocker) && blocker.owner.name != gangster.owner.name) {
		    occupied = true;
		}
	}

		// If pathing is required to get closer
    if (dist > 1 || (dist == 1 && !occupied)) {
        var path = scr_hex_a_star_path(axial.q, axial.r, sx, sy, gangster.owner.name);
        if (is_array(path) && array_length(path) > 0) {
            gangster.move_path = path;
            gangster.has_followup_move = true;
            var first_step = array_shift(gangster.move_path);
            if (array_length(gangster.move_path) == 0) gangster.has_followup_move = false;
            scr_gangster_start_movement(gangster, first_step, true);
            gangster.state = "waiting";
        }
        return;
    }

	// If adjacent but blocked by enemy — switch to ALERTED
	if (dist == 1 && occupied) {
	    // Check if the tile is still friendly before alerting
	    var tile_index = ds_map_find_value(global.hex_lookup, stronghold_key);
	    var tile = global.hex_grid[tile_index];

	    if (tile.owner != gangster.owner.name) {
	        // It's already been captured — nothing to do
	        gangster.state = "idle";
	        gangster.reserved_stronghold_key = undefined;
	        return;
	    }

	    // If still valid target, proceed to alert
	    var path = scr_hex_a_star_path(axial.q, axial.r, sx, sy, gangster.owner.name, true);
	    if (is_array(path) && array_length(path) > 0) {
	        gangster.alert_path = path;
	        gangster.alert_target_tile_index = tile_index;
	        gangster.state = "alerted";
	        gangster.is_intervening_path = true;
	        gangster.target_tile_index = tile_index;
	        gangster.path = path;
	        gangster.move_path = path;

	        var next_tile_index = array_shift(gangster.move_path);
	        scr_gangster_start_movement(gangster, next_tile_index, false);
	    }
	    return;
	}


    // Proceed with resupply if adjacent and unoccupied
    gangster.resupply_ticks_remaining++;
    if (gangster.resupply_ticks_remaining >= global.resupply_tick_cost) {
        gangster.captures_since_resupply = 0;
        gangster.resupply_ticks_remaining = 0;
        gangster.reserved_stronghold_key = undefined;
        gangster.state = "idle";
    }
}
