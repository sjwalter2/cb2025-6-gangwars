/// Draw Event
var alpha_prev = draw_get_alpha();
draw_set_alpha(bg_effect_fade * 0.15);
draw_set_color(bg_effect_color);
var effect_fn = bg_effects[bg_effect_index];
effect_fn();
draw_set_alpha(alpha_prev);

