/// scr_tick_gangster_moving(gangster)
/// Handles per-frame movement animation and post-move behavior like capturing or state transitions.

function scr_tick_gangster_moving(gangster) {

	
    // Visual indicator that the gangster is moving
    gangster.flash_timer = current_time + 150;
    gangster.flash_type = "move";

    // Ensure move target is valid
    if (!is_struct(gangster.move_target) || 
        !variable_struct_exists(gangster.move_target, "start_pos") || 
        !variable_struct_exists(gangster.move_target, "target_pos")) return;

    // Interpolate position using movement progress
    var t = gangster.move_ticks_elapsed / gangster.move_total_ticks;
    var start = gangster.move_target.start_pos;
    var target = gangster.move_target.target_pos;

    gangster.x = lerp(start.x, target.x, t);
    gangster.y = lerp(start.y, target.y, t);
    gangster.move_ticks_elapsed++;
    gangster.first_tick_bonus = 0;

    // Once movement completes
    if (gangster.move_ticks_elapsed >= gangster.move_total_ticks) {
    scr_finalize_movement(gangster);


    //// === Interrupt movement if alerted mid-path ===
    if (!gangster.alert_responding && gangster.alert_active && gangster.alert_tile_index != -1 && gangster.state != "intervening") {
		if (gangster.state == gangster.testState) 
			show_debug_message("Changed from " + gangster.testState + " to idle 11")
        gangster.state = "idle"; // Let Step event logic take over on next frame
        gangster.move_path = [];
        gangster.has_followup_move = false;
        return;
    }

    // Followup move chaining
    if (gangster.has_followup_move && array_length(gangster.move_path) > 0) {
        scr_continue_followup_path(gangster);
        return;
    }

    // Determine final tile interaction (capture, intervene, etc.)
    scr_resolve_tile_state(gangster);
}

}
