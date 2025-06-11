// Draw FPS in top-left corner
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(10, 10, "FPS: " + string(fps));