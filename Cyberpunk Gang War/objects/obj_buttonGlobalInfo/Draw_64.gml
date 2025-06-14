if(shelfActive)
{
	draw_sprite(sprite_index,0,guiX,guiY)
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(guiX + sprite_width + 5, guiY, "Show all gangster stats");
}