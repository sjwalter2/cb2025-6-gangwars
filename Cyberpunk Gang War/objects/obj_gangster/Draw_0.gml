function draw_gangster_variant(xp, yp, size) {
    var gang_color = scr_get_gang_color(owner.name);
	var body_radius = size * 0.45;
   
    // === Selection effect ===
    if (ds_list_find_index(global.selected, id) != -1) {
        var pulse = 0.5 + 0.5 * sin(current_time * 0.005);
        draw_set_color(merge_color(gang_color, c_white, pulse));
        draw_circle(xp, yp, body_radius + 6 + pulse * 2, false);

        // Optional glitch flicker lines
        if (irandom(6) == 0) {
            draw_line(xp - body_radius - 6, yp - 2, xp + body_radius + 6, yp - 2);
        }
        if (irandom(6) == 0) {
            draw_line(xp - body_radius - 6, yp + 3, xp + body_radius + 6, yp + 3);
        }
    }
	 // === Seeded RNG for visual variation
	    var hash = scr_hash_string(name);
	    random_set_seed(hash);

	    body_radius = size * random_range(0.42, 0.48);
	    var head_radius = size * random_range(0.18, 0.24);

	    // === Store width/height for hitbox
	    gangsterWidth  = max(body_radius * 2, head_radius * 2);
	    gangsterHeight = body_radius * 2 + head_radius * 2;


    // === Body ===
    draw_set_color(c_black);
    draw_circle(xp, yp + 2, body_radius + 1, false);
    draw_set_color(gang_color);
    draw_circle(xp, yp, body_radius, false);

    // === Crest ===
    var crest_type = irandom(2);
    draw_set_color(merge_color(gang_color, c_white, 0.2));
    if (crest_type == 0) {
        draw_line_width(xp, yp - body_radius + 2, xp, yp + body_radius - 2, size * 0.1);
    } else if (crest_type == 1) {
        draw_circle(xp, yp, body_radius * 0.25, false);
    }

    // === Head ===
    var head_y = yp - body_radius - head_radius + 2;
    var head_type = irandom(2);
    draw_set_color(c_black);
    if (head_type == 0) {
        draw_circle(xp, head_y, head_radius, false);
    } else if (head_type == 1) {
        draw_polygon(xp, head_y, head_radius, 6);
    } else {
        draw_triangle(xp, head_y - head_radius, xp + head_radius, head_y + head_radius, xp - head_radius, head_y + head_radius, false);
    }

    // === Visor ===
    draw_set_color(gang_color);
    var visor_style = irandom(2);
    var visor_w = head_radius * 1.4;
    var visor_h = head_radius * 0.4;

    if (visor_style == 0) {
        draw_rectangle(xp - visor_w / 2, head_y - visor_h / 2, xp + visor_w / 2, head_y + visor_h / 2, false);
    } else if (visor_style == 1) {
        draw_line_width(xp - visor_w / 2, head_y, xp + visor_w / 2, head_y, 1.5);
    } else {
        draw_circle(xp, head_y, head_radius * 0.2, false);
    }

    random_set_seed(current_time);
}

//scr_draw_path_to_target();
// Draw using hex size
draw_gangster_variant(x, y, global.hex_size);
//draw_text(x,y+40,name)
//draw_text(x,y+60,"Cash: " + string(money))
var state_color = c_white;
var current_state = state;



switch (current_state) {
    case "idle":         state_color = c_white;     break;
    case "thinking":     state_color = c_yellow;    break;
    case "deciding":     state_color = c_orange;    break;
    case "waiting":      state_color = c_aqua;      break;
    case "moving":       state_color = c_lime;      break;
    case "capturing":    state_color = c_red;       break;
    case "resupplying":  state_color = c_fuchsia;   break;
    case "intervening":  state_color = c_blue;      break;
    case "alerted":      state_color = c_maroon;    break;
}

draw_set_color(state_color);
draw_text(x, y + gangsterHeight * 0.6, string_upper(current_state));

draw_text(x, y + gangsterHeight * 1, "Captures: " + string_upper(global.resupply_tile_limit - captures_since_resupply));
if(stuck_waiting > 1)
{
	draw_text(x, y + gangsterHeight * 1.5, "Stuck: " + string(stuck_waiting));
}



if (is_array(move_path) && array_length(move_path) > 0) {
    draw_set_color(c_white);
    draw_set_alpha(0.4);
	var tx = x;
	var ty = y;
	if (is_struct(move_target)) {
	    tx = move_target.target_pos.x;
	    ty = move_target.target_pos.y;
	    draw_line_width(x, y, tx, ty, 2);

	}

    var last_x = tx;
    var last_y = ty;

    for (var i = 0; i < array_length(move_path); i++) {
        var idx = move_path[i];
        if (idx >= 0 && idx < array_length(global.hex_grid)) {
            var tile = global.hex_grid[idx];
            var pos = scr_axial_to_pixel(tile.q, tile.r);
            var tx = pos.px + global.offsetX;
            var ty = pos.py + global.offsetY;

            draw_line(last_x, last_y, tx, ty);
            last_x = tx;
            last_y = ty;
			draw_set_color(c_red);
        }
    }

    draw_set_alpha(1);

}

