/// @function scr_get_targetable_tiles(gang_name)
/// @desc Returns a ds_list of unclaimed or enemy tile indices adjacent to gang territory

function scr_get_targetable_tiles(gang_name) {
    var reachable = ds_list_create();
    var visited_keys = ds_map_create();

    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.owner == gang_name) {
            var directions = [ [1,0], [1,-1], [0,-1], [-1,0], [-1,1], [0,1] ];
            for (var d = 0; d < 6; d++) {
                var nq = tile.q + directions[d][0];
                var nr = tile.r + directions[d][1];
                var neighbor_key = scr_axial_key(nq, nr);


                if (!ds_map_exists(visited_keys, neighbor_key) && ds_map_exists(global.hex_lookup, neighbor_key)) {
                    var j = global.hex_lookup[? neighbor_key];
                    var t = global.hex_grid[j];
                    if (t.type != "core" && (is_undefined(t.owner) || t.owner != gang_name)) {
                        ds_list_add(reachable, j);
                    }
                    ds_map_add(visited_keys, neighbor_key, true);
                }
            }
        }
    }

    ds_map_destroy(visited_keys);
    return reachable;
}