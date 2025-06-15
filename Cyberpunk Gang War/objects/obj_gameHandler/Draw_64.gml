draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);


var yy = 10;
var line_height = 18;

draw_text(10, yy, "FPS: " + string(fps)); yy += line_height;
draw_text(10, yy, "Speed: " + string(global.currentSpeed)); yy += line_height;
draw_text(10, yy, "Time: " + string(global.time)); yy += line_height;
draw_text(10, yy, "Total Ticks: " + string(totalTicks)); yy += line_height;

// === Display global.selected list ===
draw_text(10, yy, "Selected:"); yy += line_height;

if (ds_exists(global.selected, ds_type_list))
{
    for (var i = 0; i < ds_list_size(global.selected); i++)
	{
        var inst = global.selected[| i];
        var name_text = "  " + string(i) + ": ";
        if (instance_exists(inst) && variable_instance_exists(inst, "name"))
		{
            name_text += inst.name;
        } else {
            name_text += "invalid";
        }
        draw_text(10, yy, name_text);
        yy += line_height;

		if(variable_instance_exists(inst,"displayStatsFull") || global.displayGangsterStatsFull)
		{
			if(inst.displayStatsFull || global.displayGangsterStatsFull)
			{
				if(variable_instance_exists(inst,"charisma"))
				{
					draw_text(10, yy, "Charisma: " + string(inst.charisma));
					yy += line_height;
				}
				if(variable_instance_exists(inst,"charisma"))
				{
					draw_text(10, yy, "Might: " + string(inst.might));
					yy += line_height;
				}
				if(variable_instance_exists(inst,"honor"))
				{
					draw_text(10, yy, "Honor: " + string(inst.honor));
					yy += line_height;
				}
			}
		}
	}
} else {
    draw_text(10, yy, "(no selection list)");
}

if(instance_exists(gui_button_shelf))
{
	gui_button_shelf.lineHeight = line_height
	yy += line_height;
	gui_button_shelf.guiY = yy
	yy += gui_button_shelf.shelfHeight
}


global.tooltip_boxes_drawn = [];
