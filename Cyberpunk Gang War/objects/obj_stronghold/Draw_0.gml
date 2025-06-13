function draw_stronghold_variant(xp, yp, size) {
	var stronghold_color = c_gray;
	var tile = global.hex_grid[tile_index];
	if (!is_undefined(tile.owner)) {
		stronghold_color = scr_get_gang_color(tile.owner);
	}

	var hash = scr_hash_string(name);
	random_set_seed(hash);

	var base_radius = size * random_range(0.5, 0.75);
	var core_radius = base_radius * random_range(0.35, 0.55);
	var style = irandom_range(0, 2); // 0 = basic, 1 = mid, 2 = complex

	// === Softer Pulse Ring on Selection ===
	if (ds_list_find_index(global.selected, id) != -1) {
		draw_set_alpha(.5)
	    var pulse = 0.3 + 0.2 * sin(current_time * 0.005);
	    var ring_radius = base_radius + 3 + pulse * 1.5;
	
	    draw_set_color(merge_color(stronghold_color, c_white, pulse));
	    draw_circle(xp, yp, ring_radius, false);

	    // Occasional subtle glitch line (fainter, less often)
	    if (style == 2 && irandom(6) == 0) {
	        draw_set_color(merge_color(stronghold_color, c_white, 0.1));
	        draw_line(xp - base_radius - 4, yp + 2, xp + base_radius + 4, yp + 2);
	    }
		draw_set_alpha(1)
	}


	// === Base ring or segments ===
if (style == 0) {
    // Simple base circle with soft glow ring and one accent
    draw_set_color(merge_color(stronghold_color, c_black, 0.2));
    draw_circle(xp, yp, base_radius * 1.05, false);

    draw_set_color(stronghold_color);
    draw_circle(xp, yp, base_radius * 0.85, true);

    // Optional tiny antenna or panel (for asymmetry)
    if (irandom(1)) {
        draw_set_color(merge_color(stronghold_color, c_white, 0.2));
        var panel_h = base_radius * 0.5;
        var offset_x = base_radius * 0.7;
        draw_rectangle(xp + offset_x - 1.5, yp - panel_h / 2, xp + offset_x + 1.5, yp + panel_h / 2, true);
    }

} else {
    var tier_count = irandom_range(2, 4);
    for (var i = 0; i < tier_count; i++) {
        var r = base_radius * (1 - i * 0.22);
        var step_color = merge_color(stronghold_color, c_black, i * 0.25);
        draw_set_color(step_color);

        var segments = irandom_range(4, 7);
        for (var j = 0; j < segments; j++) {
            var a1 = degtorad((360 / segments) * j - 8);
            var a2 = degtorad((360 / segments) * j + 8);
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(xp, yp);
            draw_vertex(xp + cos(a1) * r, yp + sin(a1) * r);
            draw_vertex(xp + cos(a2) * r, yp + sin(a2) * r);
            draw_primitive_end();
        }
    }
}

	// === Central Core Shape ===
	draw_set_color(stronghold_color);
	var core_shape = irandom(2);
	if (core_shape == 0) {
		draw_circle(xp, yp, core_radius, true);
	} else if (core_shape == 1) {
		draw_rectangle(xp - core_radius, yp - core_radius, xp + core_radius, yp + core_radius, true);
	} else {
		draw_triangle(xp, yp - core_radius, xp + core_radius, yp + core_radius, xp - core_radius, yp + core_radius, false);
	}

	// === Complex Add-ons Only for style 2 ===
	if (style == 2) {
		// Arcs
		var arc_count = irandom_range(1, 3);
		for (var i = 0; i < arc_count; i++) {
			var angle = degtorad(irandom(360));
			var arc_radius = base_radius * random_range(0.6, 0.85);
			var arc_len = degtorad(irandom_range(30, 80));

			draw_set_color(merge_color(stronghold_color, c_white, 0.3));
			draw_primitive_begin(pr_linestrip);
			for (var a = angle; a <= angle + arc_len; a += degtorad(8)) {
				var px = xp + cos(a) * arc_radius;
				var py = yp + sin(a) * arc_radius;
				draw_vertex(px, py);
			}
			draw_primitive_end();
		}

		// Panels / Antennas
		draw_set_color(merge_color(stronghold_color, c_white, 0.25));
		if (irandom(1)) {
			var offset_x = base_radius * random_range(0.5, 0.9);
			var panel_h = base_radius * 0.8;
			draw_rectangle(xp + offset_x - 2, yp - panel_h / 2, xp + offset_x + 2, yp + panel_h / 2, true);
		}
		if (irandom(1)) {
			var offset_y = base_radius * random_range(0.5, 0.9);
			var antenna_len = base_radius * 0.8;
			draw_line(xp - 1, yp + offset_y, xp - 1, yp + offset_y + antenna_len);
		}
	}

	random_set_seed(current_time);
}



draw_stronghold_variant(x, y, global.hex_size);
