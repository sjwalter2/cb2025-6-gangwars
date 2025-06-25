draw_sprite_ext(sprite_index,image_index,guiX,guiY,1,1,0,c_white,image_alpha)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
if(variable_global_exists(variable))
{
	draw_text(guiX + sprite_width + 5, guiY, text + ": " + string(variable_global_get(variable)));
}
