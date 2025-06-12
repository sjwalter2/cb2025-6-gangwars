if ((is_moving || move_queued) && move_target != undefined) {
    var start = move_target.start_pos;
    var target = move_target.target_pos;
    var total_ticks = move_total_ticks;

    var base_tick = is_moving ? move_ticks_elapsed : 0;
    var tick_progress = 0;


    
    // Blend current tick and one full tick for the first animation leg
    var time = global.time;

	if(move_queued)
	{	
		time  -=	(global.tickTime - first_tick_bonus) 
	}
	else if(first_tick_bonus != 0)
		time += first_tick_bonus
			
    tick_progress = time / (global.tickTime + first_tick_bonus);


    var t = (base_tick + tick_progress) / total_ticks;
    t = clamp(t, 0, 1);

    x = lerp(start.x, target.x, t);
    y = lerp(start.y, target.y, t);
}
