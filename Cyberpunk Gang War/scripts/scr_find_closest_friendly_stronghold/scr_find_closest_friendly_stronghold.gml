/// @function scr_find_closest_friendly_stronghold(gang_name, x, y)
/// @returns axial_key of closest stronghold, or undefined if none

function scr_find_closest_friendly_stronghold(gang_name, x, y) {
    var min_dist = 99999;
    var best_key = undefined;

    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);

    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type == "stronghold" && tile.owner == gang_name) {
            var d = scr_axial_distance(axial.q, axial.r, tile.q, tile.r);
            if (d < min_dist) {
                min_dist = d;
                best_key = scr_axial_key(tile.q, tile.r);
            }
        }
    }

    return best_key;
}
