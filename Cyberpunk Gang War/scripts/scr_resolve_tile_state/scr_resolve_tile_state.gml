/// @function scr_resolve_tile_state(gangster)
/// @desc Evaluates the gangster's final tile and transitions to capturing, intervening, or resupplying as needed.

function scr_resolve_tile_state(gangster) {
    var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var key = scr_axial_key(axial.q, axial.r);
    if (!ds_map_exists(global.hex_lookup, key)) return;

    var final_tile_index = global.hex_lookup[? key];
    var tile = global.hex_grid[final_tile_index];



	// === Check if this is the alert tile ===
    var q = axial.q;
    var r = axial.r;

    var found_capturer_here = false;
    var debug_output = "🧠 Intervene Debug:\n";
    debug_output += "Self: " + gangster.name + " — state: " + gangster.state + " @ (" + string(q) + "," + string(r) + ")\n";

    with (obj_gangster) {
        var their_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
        var their_q = their_axial.q;
        var their_r = their_axial.r;

        var line = " - " + name + " — state: " + state + " @ (" + string(their_q) + "," + string(their_r) + ")";
        if (state == "capturing") {
            line += " [ticks left: " + string(capture_ticks_remaining) + "]";
        }
        debug_output += line + "\n";

        if (id != other.id && state == "capturing" && their_q == q && their_r == r) {
            found_capturer_here = true;
        }
    }

    if (found_capturer_here) {
        gangster.state = "intervening";
		gangster.intervene_tile = tile;
		gangster.proper_intervene_reset = 0;
        gangster.alert_active = false;
        show_debug_message(debug_output);
        show_debug_message("✅ Enemy gangster capturing on tile (" + string(q) + "," + string(r) + ") — transitioning to intervene");
        return;
    } else if (gangster.alert_active && final_tile_index == gangster.alert_tile_index) {
        show_debug_message(debug_output);
        show_debug_message("⚠️ No enemy gangster capturing on tile (" + string(q) + "," + string(r) + ") — alert cleared");
        gangster.alert_active = false;
        gangster.alert_responding = false;
        gangster.alert_tile_index = -1;
		if (gangster.state == gangster.testState) 
				show_debug_message("Changed from " + gangster.testState + " to idle 9")
        gangster.state = "idle";
		return
    }
//}

	
    // === Handle Capture Attempt ===
    if (tile.owner != gangster.owner.name) {
        gangster.state = "capturing";
		gangster.proper_capture_reset = 0;
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
