var base_y = display_get_gui_height() - 32;
var spacing = 24;

for (var i = 0; i < array_length(messages); i++) {
    var m = messages[i];
    var age = current_time - m.time_created;
    var fade = 1 - (age / m.duration);
    var yy = base_y - i * spacing;

    draw_set_alpha(fade);
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_left);

    // Build message parts
    var msg_prefix = "Gangster " + string(m.gangster) + " of the ";
    var msg_tile = " captured tile (" + string(m.q) + "," + string(m.r) + ")";
    var msg_suffix = "";
    if (!is_undefined(m.prev_owner)) {
        msg_suffix = " from " + string(m.prev_owner);
    }

    // Measure text widths
    var prefix_width = string_width(msg_prefix);
    var gang_width = string_width(string(m.new_owner));
    var tile_width = string_width(msg_tile);

    // Draw "Gangster X of the "
    draw_set_color(c_white);
    draw_text(16, yy, msg_prefix);

    // Draw gang name in its color
    draw_set_color(m.new_color);
    draw_text(16 + prefix_width, yy, string(m.new_owner));

    // Draw tile part
    draw_set_color(c_white);
    draw_text(16 + prefix_width + gang_width, yy, msg_tile);

    // Draw "from Z" in previous owner's color (if present)
    if (!is_undefined(m.prev_owner)) {
        draw_set_color(m.prev_color);
        draw_text(16 + prefix_width + gang_width + tile_width, yy, msg_suffix);
    }
}

// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
