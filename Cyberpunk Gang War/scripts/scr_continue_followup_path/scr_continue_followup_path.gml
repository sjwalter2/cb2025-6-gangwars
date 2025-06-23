/// @function scr_continue_followup_path(gangster)
/// @desc Handles chaining movement along a stored path (e.g., for queued movement across tiles).

function scr_continue_followup_path(gangster) {
    var next_tile_index = array_shift(gangster.move_path);
    if (array_length(gangster.move_path) == 0) {
        gangster.has_followup_move = false;
    }

    var next_tile = global.hex_grid[next_tile_index];
    var next_key = scr_axial_key(next_tile.q, next_tile.r);

    // If tile is already occupied, cancel movement
    if (ds_map_exists(global.gangster_tile_map, next_key)  && !gangster.alert_responding && gangster.state != "intervening") {
		if (gangster.state == gangster.testState) 
				show_debug_message("Changed from " + gangster.testState + " to idle 7")
        gangster.state = "idle";
        gangster.move_path = [];
        gangster.has_followup_move = false;
        gangster.reserved_stronghold_key = undefined;
    } else {
        scr_gangster_start_movement(gangster, next_tile_index, false);
    }
}
