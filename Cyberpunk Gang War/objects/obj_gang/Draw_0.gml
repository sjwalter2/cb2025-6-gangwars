if (global.debugMode) {
    var reachable = scr_get_targetable_tiles(name);
    var gang_color = scr_get_gang_color(name);

    draw_set_color(gang_color);
    draw_set_alpha(0.4);

    for (var i = 0; i < ds_list_size(reachable); i++) {
        var tile_index = reachable[| i];
        var tile = global.hex_grid[tile_index];
        var pos = scr_axial_to_pixel(tile.q, tile.r);
        draw_circle(global.offsetX + pos.px, global.offsetY + pos.py, 6, false);
    }

    draw_set_alpha(1);
    ds_list_destroy(reachable);
}
