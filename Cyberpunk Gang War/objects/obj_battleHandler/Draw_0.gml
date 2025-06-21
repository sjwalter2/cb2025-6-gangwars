// Calculate center screen position for 1280x720
var win_w = 1280;
var win_h = 720;

var win_x = (camera_get_view_width(view_camera[0]) - win_w) / 2 + camera_get_view_x(view_camera[0]);
var win_y = (camera_get_view_height(view_camera[0]) - win_h) / 2 + camera_get_view_y(view_camera[0]);


// Cyberpunk border (glow-like neon effect)
draw_set_color(c_aqua);
draw_rectangle(win_x - 2, win_y - 2, win_x + win_w + 2, win_y + win_h + 2, false);

draw_set_color(c_fuchsia);
draw_rectangle(win_x - 4, win_y - 4, win_x + win_w + 4, win_y + win_h + 4, false);

// Background fill
draw_set_color(make_color_rgb(10, 10, 20));
draw_rectangle(win_x, win_y, win_x + win_w, win_y + win_h, false);


// Inner data text
draw_set_color(c_white);
draw_text(win_x + 50, win_y + 50, "⚔ Manual Battle in Progress ⚔");
draw_text(win_x + 50, win_y + 100, "Attacker: " + battle_data.attacker.owner.name);
draw_text(win_x + 50, win_y + 140, "Defender: " + battle_data.defender.owner.name);
