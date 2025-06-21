if(global.inputLocked) exit;
var is_hovered = false;
var gui_pos = scr_world_to_gui(x, y);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Bounding box for hover check (smaller than hex)
if (abs(mx - gui_pos.x) < global.hex_size * 0.4 &&
    abs(my - gui_pos.y) < global.hex_size * 0.4) {
    is_hovered = true;
}

if (is_hovered || (ds_exists(global.selected, ds_type_list) && ds_list_find_index(global.selected, self) != -1)) {
    var gang_name = "";
    var text_color = c_grey;

    if (!is_undefined(tile_index)) {
        var tile = global.hex_grid[tile_index];
        if (!is_undefined(tile.owner)) {
            gang_name = tile.owner;
            text_color = scr_get_gang_color(gang_name);
        }
    }

    var exclude_tiles = ds_list_create();
    ds_list_add(exclude_tiles, string(q) + "," + string(r));

    scr_draw_tooltip(name, gang_name, x, y, exclude_tiles, text_color);

    ds_list_destroy(exclude_tiles);
}
