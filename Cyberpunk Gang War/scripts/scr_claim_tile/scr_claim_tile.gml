function scr_claim_tile(capture_tile_index, newOwner)
{
	var tile = global.hex_grid[capture_tile_index];
	var previous_owner = tile.owner;
	var previous_color = scr_get_gang_color(previous_owner);
	// Finalize capture
	tile.owner = newOwner.name;
	tile.color = scr_get_gang_color(newOwner.name);
	tile.pending_owner = undefined;
	tile.pending_color = undefined;
	tile.flicker_enabled = false;
	tile.capture_time = current_time;

	// Store changes
	global.hex_grid[capture_tile_index] = tile;

	// Add to gang territory
	for (var i = 0; i < array_length(global.gang_territories); i++) {
	    if (global.gang_territories[i].name == newOwner.name) {
	        var already_owned = false;
			for (var j = 0; j < array_length(global.gang_territories[i].owned); j++) {
			    if (global.gang_territories[i].owned[j] == capture_tile_index) {
			        already_owned = true;
			        break;
			    }
			}

			if (!already_owned) {
			    array_push(global.gang_territories[i].owned, capture_tile_index);
			}

	    }
	}

	// Update visuals
	with(obj_map)
	{
		update_tile_borders(capture_tile_index);
		update_tile_borders_for_neighbors(capture_tile_index);
	}



	// Log capture
	if (object_exists(obj_eventLogger)) {
	scr_log_capture_event(
	    name, // the gangster's name (e.g. "Johnny Wick")
	    newOwner.name,
	    tile.color,
	    tile.q,
	    tile.r,
	    previous_owner,
	    previous_color
	);

	}
}
