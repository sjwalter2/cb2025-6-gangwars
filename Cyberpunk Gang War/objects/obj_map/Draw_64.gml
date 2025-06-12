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

// === DRAW INFO IF MOUSE IS OVER A TILE

if (on_board && draw_gui) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);

    if (!is_undefined(hover_owner)) {
        draw_text(mx, my - 10, hover_owner);
    }

    var coord_text = "(" + string(hover_q) + ", " + string(hover_r) + ")";
    draw_text(mx, my + 8, coord_text);
}
draw_gui = 1;