/// @function scr_resolve_tile_state(gangster)
/// @desc Evaluates the gangster's final tile and transitions to capturing, intervening, or resupplying as needed.

function scr_resolve_tile_state(gangster) {
    var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var key = scr_axial_key(axial.q, axial.r);
    if (!ds_map_exists(global.hex_lookup, key)) return;

    var final_tile_index = global.hex_lookup[? key];
    var tile = global.hex_grid[final_tile_index];




	// === Check if this is the alert tile ===
    if (gangster.alert_active && final_tile_index == gangster.alert_tile_index)   {
        gangster.state = "intervening";
        gangster.alert_active = false;
        return;
    }
	
    // === Handle Capture Attempt ===
    if (tile.owner != gangster.owner.name) {
        gangster.state = "capturing";

        var move_cost = global.cost_unclaimed;
        if (!is_undefined(tile.owner)) move_cost = global.cost_enemy;
        if (tile.type == "stronghold") move_cost *= 2;

        gangster.capture_ticks_remaining = move_cost * 5;
        gangster.capture_tile_index = final_tile_index;


        // Trigger flicker visual
        var tile_ref = global.hex_grid[final_tile_index];
        tile_ref.flicker_enabled = true;
        tile_ref.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
        tile_ref.flicker_next = current_time + 1000;
        tile_ref.flicker_on = false;
        tile_ref.pending_color = scr_get_gang_color(gangster.owner.name);
        tile_ref.pending_owner = gangster.owner.name;
        global.hex_grid[final_tile_index] = tile_ref;

        return;
    }
	
    // === Otherwise, check if they need to resupply ===
    gangster.state = (gangster.captures_since_resupply >= global.resupply_tile_limit)
        ? "resupplying" : "idle";
}
