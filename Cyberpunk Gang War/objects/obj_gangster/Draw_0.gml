function draw_gangster_variant(xp, yp, size) {
    var gang_color = scr_get_gang_color(owner.name);

    // === Seeded RNG for visual variation
    var hash = scr_hash_string(name);
    random_set_seed(hash);

    var body_radius = size * random_range(0.42, 0.48);
    var head_radius = size * random_range(0.18, 0.24);

    // === Store width/height for hitbox
    gangsterWidth  = max(body_radius * 2, head_radius * 2);
    gangsterHeight = body_radius * 2 + head_radius * 2;

    // === Selection effect ===
    if (ds_list_find_index(global.selected, self) != -1) {
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


// Draw using hex size
draw_gangster_variant(x, y, global.hex_size);
//draw_text(x,y+40,name)
//draw_text(x,y+60,"Cash: " + string(money))

if (global.debugMode && is_array(path) && array_length(path) > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(1);

    var prev_pos = scr_world_to_gui(x, y);

    for (var i = 0; i < array_length(path); i++) {
        var tile_index = path[i];
        var tile = global.hex_grid[tile_index];
        var axial = scr_axial_to_pixel(tile.q, tile.r);
        var pos = scr_world_to_gui(axial.px + global.offsetX, axial.py + global.offsetY);

        var move_cost = obj_gameHandler.cost_enemy;
        if (is_undefined(tile.owner) || tile.owner == "") move_cost = obj_gameHandler.cost_unclaimed;
        else if (tile.owner == owner.name) move_cost = obj_gameHandler.cost_friendly;

        draw_set_color(c_red);
        draw_line(prev_pos.x, prev_pos.y, pos.x, pos.y);

        draw_set_color(c_white);
        draw_text(pos.x, pos.y, string(move_cost));

        prev_pos = pos;
    }
}

