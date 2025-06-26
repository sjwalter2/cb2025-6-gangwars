if displayReady
{
	
	
	var line_space = 5

	draw_set_colour(c_maroon)
	if(playerGang != noone) {
		draw_set_colour(scr_get_gang_color(playerGang.name))
	}
	draw_rectangle(_width/5-display_outer_rect,_height/5-display_outer_rect,_width-(_width/5)+display_outer_rect,_height-(_height/5)+display_outer_rect,false)	
	draw_set_colour(c_dkgray)
	draw_rectangle(_width/5,_height/5,_width-(_width/5),_height-(_height/5),false)
	
	
	var yy = _height/5
	
	var oldfont = draw_get_font()
	draw_set_font(bigfont)
	draw_set_colour(c_white)
	draw_set_halign(fa_center)
	
	draw_text_ext(_width/2,yy,name,16,_width/2)
	yy += string_height(name) + line_space

	draw_sprite(spr_questImages,image,_width/2,yy)
	yy += sprite_get_height(spr_questImages) + line_space

	
	draw_set_font(font)
	draw_text_ext(_width/2,yy,description,16,_width/2)
	yy += string_height(description) + line_space

	draw_set_font(oldfont)
}