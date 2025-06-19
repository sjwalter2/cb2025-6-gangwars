/// @function scr_check_gang_defeat(defeated_gang_name)
/// @description Checks if the gang has been defeated, removes tiles and gangsters

function scr_check_gang_defeat(defeated_gang_name) {
	// Check if gang has any strongholds left
	if(defeated_gang_name == undefined) exit;
    var has_stronghold = false;
    for (var i = 0; i < array_length(global.stronghold_instances); i++) {
        var s = global.stronghold_instances[i];
        var idx = s.tile_index;
        var tile = global.hex_grid[idx];
        if (tile.owner == defeated_gang_name) {
            has_stronghold = true;
            break;
        }
    }

    if (has_stronghold) return; // Not defeated
	var defeatedColor = scr_get_gang_color(defeated_gang_name)
    // Check if all gangsters of this gang are exhausted
    var exhausted = true;
	// Check if all gangsters are already trying to resupply
	with (obj_gangster) {
	    if (owner.name == defeated_gang_name && state != "resupplying") {
	        exhausted = false;
	    }
	}


    if (!exhausted) return;
	
    var tiles_to_clear = [];

    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.owner == defeated_gang_name) {
            tile.owner = undefined;
            tile.pending_owner = undefined;
            tile.color = make_color_rgb(80, 80, 80);
            tile.pending_color = undefined;

            tile.flicker_enabled = false;
            tile.flicker_on = false;
            tile.flicker_count = 0;
            tile.flicker_timer = 0;
            tile.flicker_next = 0;
            tile.flicker_target = undefined;
            tile.capture_time = -1;

            if (tile.type == "stronghold") {
                tile.type = "outer"; // optionally change back to outer
            }

            global.hex_grid[i] = tile;
			with(obj_map)
			{
	            update_tile_borders(i);
	            update_tile_borders_for_neighbors(i);
			}
        }
    }

    // Remove gangsters from the defeated gang
    with (obj_gangster) {
        if (owner.name == defeated_gang_name) {
            instance_destroy();
        }
    }

    // Remove gang entry
    for (var j = 0; j < array_length(global.gang_territories); j++) {
        if (global.gang_territories[j].name == defeated_gang_name) {
            array_delete(global.gang_territories, j, 1);
            break;
        }
    }

    // Log event
    if (object_exists(obj_eventLogger)) {
	    scr_log_gang_defeated_event(defeated_gang_name, defeatedColor);
	}
}
