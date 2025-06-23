/// Step Event
if (nextSpeed == 0) {
    global.currentSpeed = 0;
}
else if (global.currentSpeed == 0 && nextSpeed != 0) {
    global.currentSpeed = nextSpeed;
}

if (global.currentSpeed > 0) {
	

    global.time += global.currentSpeed;

    // During tick: process 1 gangster from thinking queue per frame
    if (!ds_queue_empty(global.gangster_thinking_queue)) {
        var g = ds_queue_dequeue(global.gangster_thinking_queue);
        if (instance_exists(g) && g.state == "thinking") {
            g.state = "deciding";
        }
    }

    if (global.time >= global.tickTime) {
        global.time = 0;
        totalTicks++;

        // Refill thinking queue at start of each tick
        with (obj_gangster) {
            if (state == "idle" && autonomous) {
                state = "thinking";
                ds_queue_enqueue(global.gangster_thinking_queue, id);
            }
        }

        // Run tick for all tickers
        for (var i = 0; i < ds_list_size(tickers); i++) {
            with (ds_list_find_value(tickers, i)) {
                tick();
            }
        }
		with(obj_gangster)
			moving_tick()

        global.currentSpeed = nextSpeed;
    }
}

global.selection_cooldown = false;

// Toggle pause
if (global.inputLocked) exit;
if (keyboard_check_pressed(vk_space)) {
    if (nextSpeed == 0)
        nextSpeed = 1;
    else
        nextSpeed = 0;
}
