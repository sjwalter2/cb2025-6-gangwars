/// @function scr_gangster_start_movement(gangster, target_tile_index)
/// @desc Queues movement for a gangster to begin on the next tick.
/// @param gangster - the gangster instance
/// @param target_tile_index - index into global.hex_grid

function scr_gangster_start_movement(gangster, target_tile_index) {
	
    if (!instance_exists(gangster)) exit;
    if (gangster.is_moving || gangster.move_queued) exit;
	
	// Deselect if selected
    var index = ds_list_find_index(global.selected, gangster);
    if (index != -1) ds_list_delete(global.selected, index);
	

	// Prevent duplicate claim
    if (ds_list_find_index(global.claimed_tile_indices, target_tile_index) != -1) exit;
	
    var tile = global.hex_grid[target_tile_index];

    var move_cost = moveUnowned;
    if (tile.owner == gangster.owner.name) {
        move_cost = moveFriendly;
    } else if (!is_undefined(tile.owner)) {
        move_cost = moveEnemy;
    }

    var start = { x: gangster.x, y: gangster.y };
    var pixel = scr_axial_to_pixel(tile.q, tile.r);
    var target_pos = {
        x: pixel.px + global.offsetX,
        y: pixel.py + global.offsetY
    };

    // Store movement data, but don't start yet
    gangster.move_target = {
        q: tile.q,
        r: tile.r,
        tile_index: target_tile_index,
        start_pos: start,
        target_pos: target_pos
    };
    gangster.move_ticks_elapsed = 0;
    gangster.move_total_ticks = move_cost;
    gangster.move_queued = true; // NEW: queued to start next tick
	gangster.first_tick_bonus = global.tickTime - global.time;
	
	// Claim this tile index
    ds_list_add(global.claimed_tile_indices, target_tile_index);



}
