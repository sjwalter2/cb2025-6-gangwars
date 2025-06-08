// === GET MOUSE WORLD POSITION ===
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Center camera offsets
var cx = camera_get_view_width(view_camera[0]) / 2;
var cy = camera_get_view_height(view_camera[0]) / 2;

var world_x = mx - cx;
var world_y = my - cy;

// Convert to axial coordinates
var axial = pixel_to_axial(world_x, world_y);
var hover_q = axial.q;
var hover_r = axial.r;

// Find the tile
var hover_owner = "";
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    if (tile.q == hover_q && tile.r == hover_r) {
        if (!is_undefined(tile.owner)) {
            hover_owner = tile.owner;
        }
        break;
    }
}

// Draw the name
if (hover_owner != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text(mx, my - 10, hover_owner);
}
