/// Step Event

// Movement animation interpolation
if ((is_moving || move_queued) && move_target != undefined) {
    var start = move_target.start_pos;
    var target = move_target.target_pos;
    var total_ticks = move_total_ticks;

    var base_tick = is_moving ? move_ticks_elapsed : 0;
    var tick_progress = 0;

    var time = global.time;

    if (move_queued) {
        time -= (global.tickTime - first_tick_bonus);
    } else if (first_tick_bonus != 0) {
        time += first_tick_bonus;
    }

    tick_progress = time / (global.tickTime + first_tick_bonus);
    var t = (base_tick + tick_progress) / total_ticks;
    t = clamp(t, 0, 1);

    x = lerp(start.x, target.x, t);
    y = lerp(start.y, target.y, t);

}
if(state == "intervening")
	test = 1;
else
	interveneCount = 0;
if test
{
	show_debug_message("Gangster " + string(id) + " state: " + string(state));
}
if test && state != "intervening"
{
	show_debug_message("Gangster Error " + string(id) + " state: " + string(state));
}
// === Decision logic happens when dequeued ===
if (state == "deciding") {

    // === Alert response overrides normal decision ===
    if (scr_check_alert_and_respond(self)) exit;

    // === Normal AI logic continues here if no alert is active ===

    var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
    var start_key = scr_axial_key(my_axial.q, my_axial.r);
    if (!ds_map_exists(global.hex_lookup, start_key)) {
        state = "idle";
        exit;
    }

    if (captures_since_resupply >= global.resupply_tile_limit) {
        state = "resupplying";
        exit;
    }

    var gang_name = owner.name;
    var target_index = scr_gangster_ai_decide_target(self);
    if (target_index == -1 || !is_real(target_index)) {
        state = "idle";
        exit;
    }

    var goal_tile = global.hex_grid[target_index];
    var path = scr_hex_a_star_path(my_axial.q, my_axial.r, goal_tile.q, goal_tile.r, gang_name);

    if (is_array(path) && array_length(path) > 0) {
        move_path = path;
        has_followup_move = true;
        var first_step = array_shift(move_path);
        if (array_length(move_path) == 0) has_followup_move = false;
		if(stuck_waiting > 3)
			var r = 2;

        scr_gangster_start_movement(self, first_step, true);
		if(move_target != undefined)
		{
	        move_queued = true;
	        state = "waiting"; // ✅ Only if movement is valid
		}
		else
		{
			
			state = "idle"
			move_queued = false
			stuck_waiting++;
		}
    } else {
        state = "idle"; // ✅ Don't wait if no valid move
    }
}

