// === ZOOM CONTROLS ===
if (mouse_wheel_up() || keyboard_check_pressed(ord("Z"))) {
    zoom_level = clamp(zoom_level + 1, 0, zoom_max);
}
if (mouse_wheel_down() || keyboard_check_pressed(ord("X"))) {
    zoom_level = clamp(zoom_level - 1, 0, zoom_max);
}

// === FLICKER UPDATES ===
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];

    if (tile.flicker_enabled) {
        if (current_time >= tile.flicker_next && tile.flicker_count <= 0) {
            tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
            tile.flicker_count = irandom_range(FLICKER_MIN_BLIPS, FLICKER_MAX_BLIPS);
            tile.flicker_on = false;
        }

        if (tile.flicker_count > 0 && current_time >= tile.flicker_timer) {
            tile.flicker_on = !tile.flicker_on;
            tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
            if (!tile.flicker_on) {
                tile.flicker_count--;
                if (tile.flicker_count <= 0) {
                    tile.flicker_next = current_time + irandom_range(FLICKER_MIN_TIME, FLICKER_MAX_TIME);
                }
            }
        }

        tile.is_flickering = tile.flicker_on;
    } else {
        tile.is_flickering = false;
    }

    global.hex_grid[i] = tile;
}

// === DRAW HEXES ===
draw_set_alpha(1);
draw_set_color(c_white);

var center_x = display_get_width() / 4;
var center_y = display_get_height() / 4;

for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    var pos = axial_to_pixel(tile.q, tile.r);
    var draw_x = center_x + pos.px;
    var draw_y = center_y + pos.py;

    var base_col = tile.color;
    var brightness = tile.is_flickering ? 0.5 * tile.brightness : clamp(tile.brightness, 0, 1);
    var col = merge_color(base_col, c_black, 1 - brightness);

    draw_illuminated_hex(draw_x, draw_y, hex_size, col);
}
