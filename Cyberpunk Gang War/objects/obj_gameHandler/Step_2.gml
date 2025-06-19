global.buttonPressed = false

// Record current fps each frame
ds_queue_enqueue(global.fps_history, fps);

// If history is over 600 frames (~10s at 60fps), trim it
if (ds_queue_size(global.fps_history) > 600) {
    ds_queue_dequeue(global.fps_history);
}

// Recalculate worst fps every second
if (current_time - global.fps_timer > 1000) {
    global.fps_timer = current_time;

    var worst = 9999;
	var total = 0;
	var count = 0;

    var arr = ds_queue_create();
	   while (!ds_queue_empty(global.fps_history)) {
	    var val = ds_queue_dequeue(global.fps_history);
	    ds_queue_enqueue(arr, val); // temporarily hold
	    if (val < worst) worst = val;
	    total += val;
	    count += 1;
	}

    // restore queue
    while (!ds_queue_empty(arr)) {
        ds_queue_enqueue(global.fps_history, ds_queue_dequeue(arr));
    }
    ds_queue_destroy(arr);

    global.fps_worst_10s = worst;
	if (count > 0) {
	    global.fps_avg_10s = total / count;
	}

}
