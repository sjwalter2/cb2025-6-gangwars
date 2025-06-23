function scr_claim_tile(capture_tile_index, newOwner) {
    var tile = global.hex_grid[capture_tile_index];
    var previous_owner = tile.owner;
    var previous_color = scr_get_gang_color(previous_owner);

    tile.owner = newOwner.name;
    tile.color = scr_get_gang_color(newOwner.name);
    tile.pending_owner = undefined;
    tile.pending_color = undefined;
    tile.flicker_enabled = false;
    tile.capture_time = current_time;

    // Store updated tile
    global.hex_grid[capture_tile_index] = tile;

    // Add to gang territory
    for (var i = 0; i < array_length(global.gang_territories); i++) {
        if (global.gang_territories[i].name == newOwner.name) {
            if (!array_contains(global.gang_territories[i].owned, capture_tile_index)) {
                array_push(global.gang_territories[i].owned, capture_tile_index);
            }

            // Add stronghold to their resupply pool if it is a stronghold tile
            if (tile.type == "stronghold") {
                if (!array_contains(global.gang_territories[i].strongholds, capture_tile_index)) {
                    array_push(global.gang_territories[i].strongholds, capture_tile_index);
                }
            }
        }
    }

    with (obj_map) {
        update_tile_borders(capture_tile_index);
        update_tile_borders_for_neighbors(capture_tile_index);
    }

    if (object_exists(obj_eventLogger)) {
        scr_log_capture_event(
            name,
            newOwner.name,
            tile.color,
            tile.q,
            tile.r,
            previous_owner,
            previous_color
        );
    }
	with(obj_gangster)
		remaining_stronghold = scr_check_remaining_stronghold(myGang);
	scr_check_gang_defeat(previous_owner);
}
