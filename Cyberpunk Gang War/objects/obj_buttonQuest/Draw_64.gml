if(shelfActive)
{
	draw_sprite_ext(sprite_index,image_index,guiX,guiY,1,1,0,c_white,image_alpha)
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(guiX, guiY+sprite_height+5, text);
}