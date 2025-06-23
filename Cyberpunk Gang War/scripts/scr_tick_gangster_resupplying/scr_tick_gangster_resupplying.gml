/// @function scr_tick_gangster_resupplying(gangster)
/// @desc Attempts to reach a friendly stronghold and resupply.
/// @returns N/A

function scr_tick_gangster_resupplying(gangster) {
    // Retry finding a stronghold if needed
    if (!is_array(gangster.move_path) || array_length(gangster.move_path) == 0) {
        gangster.reserved_stronghold_key = scr_find_closest_stronghold(gangster.owner.name, gangster.x, gangster.y, true);
    }

    if (gangster.reserved_stronghold_key == undefined)
	{
		return;
	}

    var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var sx = floor(gangster.reserved_stronghold_key / 10000) - 5000;
    var sy = gangster.reserved_stronghold_key mod 10000 - 5000;
    var dist = scr_axial_distance(axial.q, axial.r, sx, sy);

    var occupied = false;
	var stronghold_key = scr_axial_key(sx, sy);
	var blocker = noone;
	if (ds_map_exists(global.gangster_tile_map, stronghold_key)) {
		blocker = ds_map_find_value(global.gangster_tile_map, stronghold_key);
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



    // Proceed with resupply if adjacent and unoccupied
    gangster.resupply_ticks_remaining++;
    if (gangster.resupply_ticks_remaining >= global.resupply_tick_cost) {
        gangster.captures_since_resupply = 0;
        gangster.resupply_ticks_remaining = 0;
        gangster.reserved_stronghold_key = undefined;
		if (gangster.state == gangster.testState) 
			show_debug_message("Changed from " + gangster.testState + " to idle 12")
        gangster.state = "idle";
    }
}
