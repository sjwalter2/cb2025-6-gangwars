if(global.inputLocked) exit;

// === GET MOUSE WORLD POSITION ===
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var world_pos = scr_gui_to_world(mx, my);
var world_x = world_pos.x;
var world_y = world_pos.y;

// === Convert to axial and find tile ===
var axial = scr_pixel_to_axial(world_x - global.offsetX, world_y - global.offsetY);
var hover_q = axial.q;
var hover_r = axial.r;

var hover_owner = undefined;
var on_board = false;

for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    if (tile.q == hover_q && tile.r == hover_r) {
        on_board = true;
        if (!is_undefined(tile.owner)) {
            hover_owner = tile.owner;
        }
        break;
    }
}

if (on_board && draw_gui) {
    var gui_x = 12;
    var gui_y = display_get_gui_height() - 180;

    var world_pos = scr_gui_to_world(gui_x, gui_y);

    var text1 = !is_undefined(hover_owner) ? hover_owner : "";
    var text2 = "(" + string(hover_q) + ", " + string(hover_r) + ")";

    var exclude = ds_list_create();
    with (obj_gangster) {
        var gui_pos = scr_world_to_gui(x, y);
        var dist_x = abs(device_mouse_x_to_gui(0) - gui_pos.x);
        var dist_y = abs(device_mouse_y_to_gui(0) - gui_pos.y);
        if (dist_x < gangsterWidth * 0.5 && dist_y < gangsterHeight * 0.5) {
            var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
            ds_list_add(exclude, string(axial.q) + "," + string(axial.r));
        }
    }

    scr_draw_tooltip(text1, text2, world_pos.x, world_pos.y, exclude, scr_get_gang_color(hover_owner));
    ds_list_destroy(exclude);
}


draw_gui = 1;

