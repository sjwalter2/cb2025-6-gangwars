/// @function scr_tick_gangster_alerted(gangster)
/// @description Handles movement initiation for alerted gangsters.
///              This will queue a move just like normal pathing and allow smooth interpolation.

function scr_tick_gangster_alerted(gangster) {
    if (!gangster.is_moving && !gangster.move_queued && array_length(gangster.move_path) > 0) {
        var next_tile_index = array_shift(gangster.move_path);
        gangster.has_followup_move = array_length(gangster.move_path) > 0;

        var next_tile = global.hex_grid[next_tile_index];
        var next_key = scr_axial_key(next_tile.q, next_tile.r);

        if (ds_map_exists(global.gangster_tile_map, next_key)) {
            gangster.state = "idle";
            gangster.move_path = [];
            gangster.has_followup_move = false;
            return;
        }

        scr_gangster_start_movement(gangster, next_tile_index, true); // queue = true
        gangster.move_queued = true;
        gangster.state = "waiting";
    }
	else
		gangster.state = "idle";
}
