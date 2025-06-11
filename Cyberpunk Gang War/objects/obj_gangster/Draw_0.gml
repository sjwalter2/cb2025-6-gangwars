//draw_self()
//draw_sprite(spr_gangsterHead,sprite_head_index,x+sprite_width/2,y)

/// @description Draw stylized gangster with randomized traits

function draw_gangster_variant(xp, yp, size) {
    var gang_color = scr_get_gang_color(owner.name);

    // === Seeded RNG based on name (stable per gangster)
    var hash = scr_hash_string(name);
    random_set_seed(hash);

    // === Size settings
    var body_radius = size * random_range(0.42, 0.48);
    var head_radius = size * random_range(0.18, 0.24);

    // === Draw body (main color with subtle offset shadow)
    draw_set_color(c_black);
    draw_circle(xp, yp + 2, body_radius + 1, false);
    draw_set_color(gang_color);
    draw_circle(xp, yp, body_radius, false);

    // === Random Crest
    var crest_type = irandom(2);
    draw_set_color(merge_color(gang_color, c_white, 0.2));

    if (crest_type == 0) {
        draw_line_width(xp, yp - body_radius + 2, xp, yp + body_radius - 2, size * 0.1);
    } else if (crest_type == 1) {
        draw_circle(xp, yp, body_radius * 0.25, false);
    }

    // === Head Position
    var head_y = yp - body_radius - head_radius + 2;

    // === Head Shape Variant
    var head_type = irandom(2);
    draw_set_color(c_black);
    if (head_type == 0) {
        draw_circle(xp, head_y, head_radius, false);
    } else if (head_type == 1) {
        draw_polygon(xp, head_y, head_radius, 6); // Hex head
    } else {
        draw_triangle(xp, head_y - head_radius, xp + head_radius, head_y + head_radius, xp - head_radius, head_y + head_radius, false);
    }

    // === Visor Type
    draw_set_color(gang_color);
    var visor_style = irandom(2);
    var visor_w = head_radius * 1.4;
    var visor_h = head_radius * 0.4;

    if (visor_style == 0) {
        draw_rectangle(xp - visor_w/2, head_y - visor_h/2, xp + visor_w/2, head_y + visor_h/2, false); // Wide
    } else if (visor_style == 1) {
        draw_line_width(xp - visor_w/2, head_y, xp + visor_w/2, head_y, 1.5); // Slit
    } else {
        draw_circle(xp, head_y, head_radius * 0.2, false); // Dot eye
    }

    random_set_seed(current_time); // restore RNG
}

// Draw using hex size
draw_gangster_variant(x, y, global.hex_size);
//draw_text(x,y+40,name)
//draw_text(x,y+60,"Cash: " + string(money))
