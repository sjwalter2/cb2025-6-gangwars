/// Draw GUI Event
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Button position (GUI coordinates)
var btn_x1 = 540;
var btn_y1 = 950;
var btn_x2 = 740;
var btn_y2 = 1050;

// Button background
draw_set_color(c_dkgray);
draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, false);

// Text
draw_set_color(c_white);
draw_text(btn_x1 + 20, btn_y1 + 30, "Resolve Battle");

// Optional: hover effect
if (point_in_rectangle(mx, my, btn_x1, btn_y1, btn_x2, btn_y2)) {
    draw_set_color(c_lime);
    draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, true);
}
