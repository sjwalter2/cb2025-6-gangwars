/// @function scr_find_closest_stronghold(gang_name, x, y, require_friendly)
/// @desc Finds the closest stronghold. If require_friendly is true, only returns friendly strongholds.
/// @returns axial_key of closest valid stronghold, or undefined if none

function scr_find_closest_stronghold(gang_name, x, y, require_friendly) {
    var min_dist = 99999;
    var best_key = undefined;

    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);

    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type != "stronghold") continue;

        if (require_friendly && tile.owner != gang_name) continue;
        if (!require_friendly && tile.owner == gang_name) continue;

        // Check if tile is in claimed list
        var is_claimed = ds_list_find_index(global.claimed_tile_indices, i) != -1;
        var allowed = true;

        if (is_claimed) {
            allowed = false;

            with (obj_gangster) {
                if (is_struct(move_target) && variable_struct_exists(move_target, "tile_index")) {
                    if (move_target.tile_index == i && owner.name == gang_name) {
                        allowed = true;
                    }
                }
            }
        }

        if (!allowed) continue;

        var d = scr_axial_distance(axial.q, axial.r, tile.q, tile.r);
        if (d < min_dist) {
            min_dist = d;
            best_key = scr_axial_key(tile.q, tile.r);
        }
    }

    return best_key;
}
