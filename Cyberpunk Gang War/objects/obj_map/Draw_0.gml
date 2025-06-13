
// === FLICKER UPDATES ===
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];

    if (tile.flicker_enabled) {

	if (current_time >= tile.flicker_timer) {
	    tile.flicker_on = !tile.flicker_on;
	    tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
	}

	// Apply new color and finalize capture if pending
	if (!is_undefined(tile.pending_color) && tile.flicker_enabled == false) {
	    var previous_owner = tile.owner;
	    var previous_color = scr_get_gang_color(previous_owner);

	    var new_owner = tile.pending_owner;
	    var new_color = tile.pending_color;

	    tile.color = new_color;
	    tile.owner = new_owner;
	    tile.pending_color = undefined;
	    tile.pending_owner = undefined;
	    tile.capture_time = current_time;

	    update_tile_borders(i);
	    update_tile_borders_for_neighbors(i);

	    if (object_exists(obj_eventLogger)) {
	        scr_log_capture_event(
	            new_owner,
	            new_color,
	            tile.q,
	            tile.r,
	            previous_owner,
	            previous_color
	        );
	    }
	}


        tile.is_flickering = tile.flicker_on;
    } else {
        tile.is_flickering = false;
    }

    global.hex_grid[i] = tile;
}

// === DRAW HEXES ===
draw_set_alpha(1);
draw_set_color(c_white);

var center_x = global.offsetX;
var center_y = global.offsetY;

for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    var pos = scr_axial_to_pixel(tile.q, tile.r);
    var draw_x = center_x + pos.px;
    var draw_y = center_y + pos.py;

    // Black base hex
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(draw_x, draw_y);
    for (var a = 0; a <= 6; a++) {
        var angle = degtorad(60 * a - 30);
        var px = draw_x + cos(angle) * (hex_size+OUTLINE_THICKNESS);
        var py = draw_y + sin(angle) * (hex_size+OUTLINE_THICKNESS);
        draw_vertex(px, py);
    }
    draw_primitive_end();
	
	// === CAPTURE FLASH LOGIC ===
	var capture_duration = 5000;
	var flash_progress = 0;
	if (tile.capture_time >= 0) {
	    var time_since_capture = current_time - tile.capture_time;
	    if (time_since_capture < capture_duration) {
	        var t = time_since_capture / capture_duration;
	        flash_progress = 1 - power(t, 2); // Ease-out: fast to slow fade
	    }
	}


	// === ILLUMINATED OVERLAY COLOR ===
	// Convert gang color to HSV
	var h = color_get_hue(tile.color);
	var s = 0.5*color_get_saturation(tile.color);
	var v = 0.8*color_get_value(tile.color);

	// Get the modified color
	var base_col = make_color_hsv(h, s, v);
	if (tile.is_flickering && !is_undefined(tile.pending_color)) {
	    base_col = merge_color(tile.color, tile.pending_color, 0.6);
	}

	// Brightness logic: only boosted by capture, not by flicker
	var target_brightness = clamp(tile.brightness, 0, 1);
	if (flash_progress > 0) {
	    target_brightness = lerp(target_brightness, 1, flash_progress);
	} else if (tile.is_flickering) {
	    target_brightness = 0.5 * target_brightness;
	}

	var col = merge_color(base_col, c_black, 1 - target_brightness);
	draw_illuminated_hex(draw_x, draw_y, hex_size, col);

}
draw_set_alpha(.6)
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    var pos = scr_axial_to_pixel(tile.q, tile.r);
    var draw_x = center_x + pos.px;
    var draw_y = center_y + pos.py;

    var extension = OUTLINE_THICKNESS;
    draw_set_color(tile.color);

    for (var d = 0; d < 6; d++) {
        if (tile.border_dirs[d]) {
            var next_d = (d + 1) mod 6;
            var prev_d = (d + 5) mod 6;

            var angle1 = degtorad(60 * d - 30);
            var angle2 = degtorad(60 * next_d - 30);

            var x1 = draw_x + cos(angle1) * hex_size;
            var y1 = draw_y + sin(angle1) * hex_size;
            var x2 = draw_x + cos(angle2) * hex_size;
            var y2 = draw_y + sin(angle2) * hex_size;

            var dx = x2 - x1;
            var dy = y2 - y1;
            var length = point_distance(x1, y1, x2, y2);

            if (length != 0) {
                dx /= length;
                dy /= length;

                // Only extend points if they are not shared with another border
                var extend_start = !tile.border_dirs[prev_d]; // outer corner
                var extend_end   = !tile.border_dirs[next_d]; // outer corner

                if (extend_start) {
                    x1 -= dx * extension;
                    y1 -= dy * extension;
                }

                if (extend_end) {
                    x2 += dx * extension;
                    y2 += dy * extension;
                }
            }

            draw_line_width(x1, y1, x2, y2, OUTLINE_THICKNESS);
        }
    }
}
draw_set_alpha(1)
