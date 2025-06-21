/// Draw GUI Event
draw_set_color(c_black);
draw_rectangle(x, y, x + popup_width, y + popup_height, false);
draw_set_color(c_white);
draw_text(x + 20, y + 30, "Conflict Detected!");
draw_text(x + 20, y + 60, "Choose how to resolve:");

draw_set_color(c_gray);
draw_rectangle(x + 20, y + 100, x + 80, y + 130, false);
draw_rectangle(x + 110, y + 100, x + 170, y + 130, false);
draw_set_color(c_white);
draw_text(x + 30, y + 110, "Battle");
draw_text(x + 115, y + 110, "Automate");
