
// === FLICKER UPDATES ===
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];

    if (tile.flicker_enabled) {
        if (current_time >= tile.flicker_next && tile.flicker_count <= 0) {
            tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
            tile.flicker_count = irandom_range(FLICKER_MIN_BLIPS, FLICKER_MAX_BLIPS);
            tile.flicker_on = false;
        }

        if (tile.flicker_count > 0 && current_time >= tile.flicker_timer) {
            tile.flicker_on = !tile.flicker_on;
            tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
			if (!tile.flicker_on) {
			    tile.flicker_count--;
			    if (tile.flicker_count <= 0) {
			        tile.flicker_next = current_time + irandom_range(FLICKER_MIN_TIME, FLICKER_MAX_TIME);

			        // Apply new color and trigger capture flash AFTER flicker ends
			        if (!is_undefined(tile.pending_color)) {
			            tile.color = tile.pending_color;
			            tile.pending_color = undefined;
						tile.owner = tile.pending_owner;
						tile.pending_owner = undefined;
			            tile.capture_time = current_time;
			        }
			    }
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

var center_x = camera_get_view_width(view_camera[0]) / 2;
var center_y = camera_get_view_height(view_camera[0]) / 2;

for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    var pos = axial_to_pixel(tile.q, tile.r);
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

	// === BACKGROUND COLOR: white fade to black only on capture
	var bg_col = (flash_progress > 0)
	    ? merge_color(c_white, c_black, 1 - flash_progress)
	    : c_black;

	draw_set_color(bg_col);
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(draw_x, draw_y);
	for (var a = 0; a <= 6; a++) {
	    var angle = degtorad(60 * a - 30);
	    var px = draw_x + cos(angle) * (hex_size + OUTLINE_THICKNESS);
	    var py = draw_y + sin(angle) * (hex_size + OUTLINE_THICKNESS);
	    draw_vertex(px, py);
	}
	draw_primitive_end();

	// === ILLUMINATED OVERLAY COLOR ===
	var base_col = tile.color;
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