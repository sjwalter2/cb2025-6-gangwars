/// @function scr_gangster_start_movement(gangster, target_tile_index)
/// @desc Queues movement for a gangster to begin on the next tick. If part of a path, continue to next step.
/// @param gangster - the gangster instance
/// @param target_tile_index - index into global.hex_grid

function scr_gangster_start_movement(gangster, target_tile_index, firstMove=1) {
    if (!instance_exists(gangster)) exit;
    if (gangster.is_moving || gangster.move_queued) exit;

    // Prevent duplicate claim
    if (ds_list_find_index(global.claimed_tile_indices, target_tile_index) != -1) exit;

    var tile = global.hex_grid[target_tile_index];

    var move_cost = global.cost_unclaimed;
    if (tile.owner == gangster.owner.name) {
        move_cost = global.cost_friendly;
    } else if (!is_undefined(tile.owner)) {
        move_cost = global.cost_enemy;
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
    if(firstMove)
	{
		gangster.move_queued = true;
		gangster.state = "moving"
		gangster.first_tick_bonus = global.tickTime - global.time;
	}
	else
	{
		gangster.is_moving = true;
		gangster.state = "moving"
	}


    // Claim this tile index
    ds_list_add(global.claimed_tile_indices, target_tile_index);

    // If move_path exists and is not empty, prepare the next step
    if (is_array(gangster.move_path) && array_length(gangster.move_path) > 0) {
        // Remove the first step if it's the current tile
        if (gangster.move_path[0] == target_tile_index) {
            gangster.move_path = array_delete(gangster.move_path, 0, 1);
        }
        // Save for continuation after step completes
        gangster.has_followup_move = true;
    } else {
        gangster.has_followup_move = false;
    }

    // Clear selection + tooltip path
    var index = ds_list_find_index(global.selected, gangster);
    if (index != -1) ds_list_delete(global.selected, index);

    with (obj_gangster) {
		if(id != other.id) hoverPathValid = false;
    }
}
