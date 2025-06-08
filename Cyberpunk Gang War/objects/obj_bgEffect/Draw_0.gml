/// Draw Event
var alpha_prev = draw_get_alpha();
draw_set_alpha(bg_effect_fade * 0.15);
draw_set_color(bg_effect_color);
var effect_fn = bg_effects[bg_effect_index];
effect_fn();
draw_set_alpha(alpha_prev);

// Draw FPS in top-left corner
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(10, 10, "FPS: " + string(fps));