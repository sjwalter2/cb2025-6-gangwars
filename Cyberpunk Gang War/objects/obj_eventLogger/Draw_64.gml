var base_y = display_get_gui_height() - 32;
var spacing = 24;

for (var i = 0; i < array_length(messages); i++) {
    var m = messages[i];
    var age = current_time - m.time_created;
    var fade = 1 - (age / m.duration);

    var yy = base_y - i * spacing;

    var msg = "";

    if (is_undefined(m.prev_owner)) {
        msg = string(m.new_owner) + " captured tile (" + string(m.q) + "," + string(m.r) + ")";
    } else {
        msg = string(m.new_owner) + " captured tile (" + string(m.q) + "," + string(m.r) + ") from " + string(m.prev_owner);
    }

    draw_set_alpha(fade);
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_left);

    var name_split = string(m.new_owner);
    draw_set_color(m.new_color);
    draw_text(16, yy, name_split);

    if (!is_undefined(m.prev_owner)) {
        var part1 = string(m.new_owner) + " captured tile (" + string(m.q) + "," + string(m.r) + ") from ";
        var w1 = string_width(part1);

        draw_set_color(c_white);
        draw_text(16, yy, part1);

        draw_set_color(m.prev_color);
        draw_text(16 + w1, yy, string(m.prev_owner));
    } else {
        draw_set_color(c_white);
        draw_text(16 + string_width(string(m.new_owner)), yy, " captured tile (" + string(m.q) + "," + string(m.r) + ")");
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
