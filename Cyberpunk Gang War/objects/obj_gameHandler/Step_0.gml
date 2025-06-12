/// Step Event
if (nextSpeed == 0) {
    global.currentSpeed = 0;
}
else if(global.currentSpeed == 0 && nextSpeed != 0)
	global.currentSpeed = nextSpeed
		
if (global.currentSpeed > 0) {
	global.time += global.currentSpeed;

	if (global.time >= global.tickTime) {
	    global.time = 0; // Reset immediately no matter what
	    totalTicks++;

	    // Execute tick for each ticker
	    for (var i = 0; i < ds_list_size(tickers); i++) {
	        with (ds_list_find_value(tickers, i)) {
	            tick();
	        }
	    }
        global.currentSpeed = nextSpeed;
    }
}




global.selection_cooldown = false;

// Toggle pause
if (keyboard_check_pressed(vk_space)) {
    if(nextSpeed == 0)
		nextSpeed = 1;
	else
		nextSpeed = 0;
}