/// @function scr_find_closest_stronghold(gang_name, x, y, require_friendly)
/// @desc Finds the closest stronghold. If require_friendly is true, only returns friendly strongholds.
/// @returns axial_key of closest valid stronghold, or undefined if none

function scr_find_closest_stronghold(gang_name, x, y, require_friendly) {
    var min_dist = 99999;
    var best_key = undefined;

    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
	if(stuck_waiting > 3)
		var k = 1;
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type == "stronghold" ) {
            if (require_friendly && tile.owner != gang_name) continue;
            if (!require_friendly && tile.owner == gang_name) continue;
			// Skip if this tile is in the claimed tiles list
            if (ds_list_find_index(global.claimed_tile_indices, i) != -1) continue;


            var d = scr_axial_distance(axial.q, axial.r, tile.q, tile.r);
            if (d < min_dist) {
                min_dist = d;
                best_key = scr_axial_key(tile.q, tile.r);
            }
        }
    }

    return best_key;
}
