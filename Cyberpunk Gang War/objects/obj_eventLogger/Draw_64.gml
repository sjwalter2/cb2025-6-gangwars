var base_y = display_get_gui_height() - 32;
var spacing = 24;

// Draw normal messages (skip "defeat" types)
var draw_count = 0;
for (var i = 0; i < array_length(messages); i++) {
    var m = messages[i];
    if (variable_struct_exists(m, "type") && m.type == "defeat") continue;


    var age = current_time - m.time_created;
    var fade = 1 - (age / m.duration);
    var yy = base_y - draw_count * spacing;

    draw_set_alpha(fade);
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_left);

    var msg_prefix = "Gangster " + string(m.gangster) + " of the ";
    var msg_tile = " captured tile (" + string(m.q) + "," + string(m.r) + ")";
    var msg_suffix = "";
    if (!is_undefined(m.prev_owner)) {
        msg_suffix = " from " + string(m.prev_owner);
    }

    var prefix_width = string_width(msg_prefix);
    var gang_width = string_width(string(m.new_owner));
    var tile_width = string_width(msg_tile);

    draw_set_color(c_white);
    draw_text(16, yy, msg_prefix);
    draw_set_color(m.new_color);
    draw_text(16 + prefix_width, yy, string(m.new_owner));
    draw_set_color(c_white);
    draw_text(16 + prefix_width + gang_width, yy, msg_tile);

    if (!is_undefined(m.prev_owner)) {
        draw_set_color(m.prev_color);
        draw_text(16 + prefix_width + gang_width + tile_width, yy, msg_suffix);
    }

    draw_count++;
}

// Draw defeat messages
for (var i = 0; i < array_length(defeat_messages); i++) {
    var m = defeat_messages[i];
    var age = current_time - m.time_created;
    var fade = 1 - (age / m.duration);

    var yy = base_y + (i + 1) * spacing; // draw below main messages
    draw_set_alpha(fade);
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_center);

    var message_text = string(m.prev_owner) + " has been Defeated!";
    draw_set_color(m.prev_color);
    draw_text(display_get_gui_width() / 2, yy, message_text);
}


// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
