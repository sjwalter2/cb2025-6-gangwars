function scr_tick_gangster_intervening(gangster) {
    // Visual feedback
    gangster.flash_timer = current_time + 150;
    gangster.flash_type = "intervene";


    if (gangster.alert_tile_index != -1) {
        var tile = global.hex_grid[gangster.alert_tile_index];
        var capture_active = false;

        // Get axial position of the tile being captured
        var cap_q = tile.q;
        var cap_r = tile.r;

        with (obj_gangster) {
            if (state == "capturing" && capture_tile_index == gangster.alert_tile_index && myGang != gangster.myGang) {
                var pos = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
                if (pos.q == cap_q && pos.r == cap_r) {
                    capture_active = true;
                }
            }
        }

        if (!capture_active) {
            gangster.state = "idle";
        }
    } else {
        gangster.state = "idle";
    }
}
