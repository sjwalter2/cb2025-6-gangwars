if (is_moving && move_target != undefined) {
    // Determine where we're interpolating from and to
    var start = move_target.start_pos;
    var target = move_target.target_pos;

    // Compute smooth tick progress
    var base_tick = move_ticks_elapsed;
    var tick_progress = 0;

    // Only animate if not paused
    if (global.currentSpeed > 0) {
        tick_progress = global.time / global.tickTime;
    }

    var t = (base_tick + tick_progress) / move_total_ticks;
    t = clamp(t, 0, 1);

    x = lerp(start.x, target.x, t);
    y = lerp(start.y, target.y, t);
}
