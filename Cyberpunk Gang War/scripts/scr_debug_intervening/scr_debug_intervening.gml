function scr_debug_intervening(){
	if (state == "intervening") {
	    var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
	    var q = my_axial.q;
	    var r = my_axial.r;

	    var found_capturer_here = false;
	    var debug_output = "🧠 Intervene Debug:\n";
	    debug_output += "Self: " + name + " — state: " + state + " @ (" + string(q) + "," + string(r) + ")\n";

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

	    if (!found_capturer_here) {
	        show_debug_message(debug_output);
	        show_debug_message("⚠️ Intervening but no enemy gangster capturing on this tile at (" 
	            + string(q) + "," + string(r) + "). alert_active=" 
	            + string(alert_active) + ", alert_responding=" 
	            + string(alert_responding) + ", alert_tile_index=" 
	            + string(alert_tile_index));

	        alert_active = false;
	        alert_responding = false;
	        alert_tile_index = -1;
			if (state == testState) 
				show_debug_message("Changed from " + testState + " to idle 8")
	        state = "idle";
			proper_intervene_reset = 1;
	    }
	}
	// Track state history
	array_push(state_history, state);

	// Trim to max length
	if (array_length(state_history) > state_history_max) {
	    array_delete(state_history, 0, 1); // remove the oldest entry
	}

	// Print debug when improper state change
	if (state != "intervening" && !proper_intervene_reset) {
	    show_debug_message("⚠️ Unexpected intervene exit. State history:");
	    for (var i = 0; i < array_length(state_history); i++) {
	        show_debug_message(" - Frame " + string(i) + ": " + state_history[i]);
	    }
		var k = 1;
	}

	if (state != "capturing" && !proper_capture_reset) {
	    show_debug_message("⚠️ Unexpected capture exit. State history:");
	    for (var i = 0; i < array_length(state_history); i++) {
	        show_debug_message(" - Frame " + string(i) + ": " + state_history[i]);
	    }
		var k = 1;
	}
}