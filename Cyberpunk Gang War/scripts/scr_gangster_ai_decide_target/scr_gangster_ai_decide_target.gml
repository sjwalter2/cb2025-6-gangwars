/// @function scr_gangster_ai_decide_target(gangster)
/// @desc Returns the tile index of the best target for the gangster to move to using A* path cost.

function scr_gangster_ai_decide_target(gangster) {
    var gang_name = gangster.owner.name;
    var best_tile_index = -1;
    var lowest_cost = 100000;

    var my_axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var start_q = my_axial.q;
    var start_r = my_axial.r;
    var start_key = scr_axial_key(start_q, start_r);

    if (!ds_map_exists(global.hex_lookup, start_key)) return -1;

    // === STEP 1: If no strongholds, prioritize nearest unoccupied stronghold ===
    var has_stronghold = false;
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var t = global.hex_grid[i];
        if (t.type == "stronghold" && t.owner == gang_name) {
            has_stronghold = true;
            break;
        }
    }

    if (!has_stronghold) {
        for (var i = 0; i < array_length(global.hex_grid); i++) {
            var t = global.hex_grid[i];
            if (t.type == "stronghold" && t.owner != gang_name) {
                var key = scr_axial_key(t.q, t.r);
                if (ds_map_exists(global.gangster_tile_map, key)) continue; // skip occupied

                var path = scr_hex_a_star_path(start_q, start_r, t.q, t.r, gang_name);
                if (is_array(path) && array_length(path) > 0) {
                    return i; // 🔺 Highest priority if gang has no strongholds
                }
            }
        }
    }

    // === STEP 2: If any stronghold is reachable from adjacent gang tiles, prioritize that ===
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type == "stronghold" && tile.owner != gang_name) {
            for (var j = 0; j < array_length(global.hex_grid); j++) {
                var neighbor = global.hex_grid[j];
                if (neighbor.owner == gang_name) {
                    var d = scr_axial_distance(tile.q, tile.r, neighbor.q, neighbor.r);
                    if (d == 1) {
                        var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
                        if (is_array(path) && array_length(path) > 0) {
                            return i; // 🔹 Prioritize reachable adjacent strongholds
                        }
                    }
                }
            }
        }
    }

    // === STEP 3: Try to find enemy/unclaimed tile in range
    var targets = scr_get_targetable_tiles(gang_name);
    if (ds_list_size(targets) == 0) {
        ds_list_destroy(targets);
        return -1;
    }

    var total_targets = ds_list_size(targets);
    var max_checks = min(10, total_targets);

    for (var check = 0; check < max_checks; check++) {
        var rand_index = irandom(ds_list_size(targets) - 1);
        var target_index = targets[| rand_index];
        ds_list_delete(targets, rand_index);

        var tile = global.hex_grid[target_index];
        var axial_dist = scr_axial_distance(start_q, start_r, tile.q, tile.r);
        if (axial_dist > 5) continue;
        var key = scr_axial_key(tile.q, tile.r);
		if (tile.owner == gang_name || ds_map_exists(global.tile_reservations, key)) continue;


        var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
        if (!is_array(path) || array_length(path) == 0) continue;

        if (array_length(path) <= 3) {
            var total_cost = 0;
            for (var j = 0; j < array_length(path); j++) {
                var step_tile = global.hex_grid[path[j]];
                if (step_tile.owner == gang_name) total_cost += global.cost_friendly;
                else if (step_tile.owner == "") total_cost += global.cost_unclaimed;
                else total_cost += global.cost_enemy;
            }

            if (total_cost < lowest_cost) {
                lowest_cost = total_cost;
                best_tile_index = target_index;
            }
        }
    }

    ds_list_destroy(targets);
    if (best_tile_index != -1) return best_tile_index;

    // === STEP 4: fallback to a friendly tile at distance 3
    var fallback_candidates = [];
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.owner == gang_name) {
            var d = scr_axial_distance(start_q, start_r, tile.q, tile.r);
            if (d == 3) array_push(fallback_candidates, i);
        }
    }

    if (array_length(fallback_candidates) > 0) {
        return fallback_candidates[irandom(array_length(fallback_candidates) - 1)];
    }

    return -1;
}
