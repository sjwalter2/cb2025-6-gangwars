if displayReady
{
	
	
	var line_space = 5
	var _width = camera_get_view_width(view_camera[0])
	var _height = camera_get_view_height(view_camera[0])

	draw_set_colour(c_maroon) //TODO: set this to gang's color?
	draw_rectangle(_width/5-display_outer_rect,_height/5-display_outer_rect,_width-(_width/5)+display_outer_rect,_height-(_height/5)+display_outer_rect,false)	
	draw_set_colour(c_dkgray)
	draw_rectangle(_width/5,_height/5,_width-(_width/5),_height-(_height/5),false)
	
	
	var yy = _height/3
	
	var oldfont = draw_get_font()
	draw_set_font(bigfont)
	draw_set_colour(c_white)
	draw_set_halign(fa_center)
	
	draw_text_ext(_width/2,yy,name,16,_width/2)
	yy += string_height(name) + line_space

	//TODO:
	//image
	
	draw_set_font(font)
	draw_text_ext(_width/2,yy,description,16,_width/2)
	yy += string_height(description) + line_space

	draw_set_font(oldfont)
}