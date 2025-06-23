function scr_stop_capture(gangster){
if (gangster.capture_tile_index >= 0 && gangster.capture_tile_index < array_length(global.hex_grid)) {
        var tile1 = global.hex_grid[gangster.capture_tile_index];
        tile1.flicker_enabled = false;
        tile1.flicker_timer = 0;
        tile1.flicker_next = 0;
        tile1.flicker_on = false;
        tile1.pending_color = c_white;
        tile1.pending_owner = "";
        global.hex_grid[gangster.capture_tile_index] = tile1;
    }

    gangster.capture_tile_index = -1;
    gangster.capture_ticks_remaining = 0;
    gangster.flash_timer = current_time + 300;
    gangster.flash_type = "complete";

    gangster.state = (gangster.captures_since_resupply >= global.resupply_tile_limit)
        ? "resupplying" : "idle";
			
}