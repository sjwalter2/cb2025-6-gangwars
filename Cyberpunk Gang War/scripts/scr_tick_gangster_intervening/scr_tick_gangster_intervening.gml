/// @function scr_tick_gangster_intervening(gangster)
/// @desc Holds position while monitoring the tile being captured. Returns to idle if capture ends.


function scr_tick_gangster_intervening(gangster) {
    // Visual feedback
    gangster.flash_timer = current_time + 150;
    gangster.flash_type = "intervene";

    // Validate tile index
    var tile_index = gangster.alert_target_tile_index;
    if (is_undefined(tile_index)) {
        gangster.state = "idle";
        gangster.alert_target_tile_index = -1;
        gangster.alerted_by = noone;
        return;
    }

    // Get tile
    var tile = global.hex_grid[tile_index];

    // Check if anyone is still capturing this tile
    var capture_active = false;

    with (obj_gangster) {
        if (state == "capturing" && capture_tile_index == tile_index && owner.name != gangster.owner.name) {
            capture_active = true;
        }
    }

    // If no one is still capturing it, go idle
    if (!capture_active) {
        gangster.state = "idle";
        gangster.alert_target_tile_index = -1;
        gangster.alerted_by = noone;
    }
}
