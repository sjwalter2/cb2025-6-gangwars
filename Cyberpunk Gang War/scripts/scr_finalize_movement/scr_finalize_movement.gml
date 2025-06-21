function scr_finalize_movement(gangster) {
    // Snap to final position
    gangster.x = gangster.move_target.target_pos.x;
    gangster.y = gangster.move_target.target_pos.y;

    // Unreserve tile
    var idx = ds_list_find_index(global.claimed_tile_indices, gangster.move_target.tile_index);
    if (idx != -1) ds_list_delete(global.claimed_tile_indices, idx);

    // Reset movement state
    gangster.is_moving = false;
    gangster.move_target = undefined;
    gangster.move_ticks_elapsed = 0;
    gangster.move_total_ticks = 0;

    // Flash effect
    gangster.flash_timer = current_time + 300;
    gangster.flash_type = "arrive";


	
}
