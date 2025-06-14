var is_hovered = false;
var gui_pos = scr_world_to_gui(x, y);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (abs(mx - gui_pos.x) < gangsterWidth * 0.5 &&
    abs(my - gui_pos.y) < gangsterHeight * 0.5) {
    is_hovered = true;
}

if (is_hovered || (ds_exists(global.selected, ds_type_list) && ds_list_find_index(global.selected, self) != -1)) {
    var gang_name = "Unknown Gang";
    if (instance_exists(owner) && variable_instance_exists(owner, "name")) {
        gang_name = owner.name;
    }

    var exclude_tiles = ds_list_create();
    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
    ds_list_add(exclude_tiles, string(axial.q) + "," + string(axial.r));

    scr_draw_tooltip(name, gang_name, x, y, exclude_tiles,scr_get_gang_color(gang_name));

    ds_list_destroy(exclude_tiles);
}

if(global.displayStatsFull ||  displayStatsFull)
{
	scr_draw_tooltip_ext(["Charisma " + string(charisma),"Might " + string(might), "Honor " + string(honor), "Party " + string(assignedPawns)],x+10,y-30,,c_green)	
}