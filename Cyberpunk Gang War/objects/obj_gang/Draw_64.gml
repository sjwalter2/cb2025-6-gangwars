if(global.displayGangStatsFull)
{
	draw_set_color(scr_get_gang_color(name));
	draw_set_halign(fa_right)
	draw_set_valign(fa_top)
	draw_text(x, y, name);
	if(!autonomous)
	{
		draw_text(x-string_width(name)-3,y,"[P]")
	}
	draw_text(x, y + 16, "Type: " + gangType);
	draw_text(x, y + 32, "Pawns: " + string(freePawns) + "/" + string(pawns));
	draw_text(x, y + 48, "Cash: $" + string(money));
	draw_text(x, y + 64, "Tiles: " + string(array_length(owned)));
}
