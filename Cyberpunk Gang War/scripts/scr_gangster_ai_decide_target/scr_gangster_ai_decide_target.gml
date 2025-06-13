/// @function scr_gangster_ai_decide_target(gangster)
/// @desc Returns the tile index of the best target for the gangster to move to using A* path cost.

function scr_gangster_ai_decide_target(gangster) {
    var gang_name = gangster.owner.name;
    var best_tile_index = -1;
    var lowest_cost = 100000;

    // Get current position
    var my_axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var start_q = my_axial.q;
    var start_r = my_axial.r;
    var start_key = string(start_q) + "," + string(start_r);

    if (!ds_map_exists(global.hex_lookup, start_key)) return -1;

    // Get all targetable tiles
    var targets = scr_get_targetable_tiles(gang_name);
    if (ds_list_size(targets) == 0) {
        ds_list_destroy(targets);
        return -1;
    }

    // --- Try to find a valid enemy/unclaimed tile within range 5 ---
var total_targets = ds_list_size(targets);
var max_checks = min(10, total_targets); // limit to 10 random samples

for (var check = 0; check < max_checks; check++) {
    var rand_index = irandom(ds_list_size(targets) - 1);
    var target_index = targets[| rand_index];
	ds_list_delete(targets, rand_index);       // ✅ correct
	// don't check it again

        var tile = global.hex_grid[target_index];
		var axial_dist = scr_axial_distance(start_q, start_r, tile.q, tile.r);
		if (axial_dist > 5) continue;

        // Skip friendly tiles
        if (tile.owner == gang_name) continue;

        var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);

        if (is_array(path) && array_length(path) > 0 && array_length(path) <= 3) {
            var total_cost = 0;
            for (var j = 0; j < array_length(path); j++) {
                var step_tile = global.hex_grid[path[j]];
                if (step_tile.owner == gang_name) {
                    total_cost += global.cost_friendly;
                } else if (step_tile.owner == "") {
                    total_cost += global.cost_unclaimed;
                } else {
                    total_cost += global.cost_enemy;
                }
            }

            if (total_cost < lowest_cost) {
                lowest_cost = total_cost;
                best_tile_index = target_index;
            }
        }
    }

    ds_list_destroy(targets);

    // ✅ If we found something, return it
    if (best_tile_index != -1) return best_tile_index;

    // --- Fallback: choose random friendly tile at axial distance 5 ---
    var fallback_candidates = [];
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.owner == gang_name) {
            var d = scr_axial_distance(start_q, start_r, tile.q, tile.r);
            if (d == 3) array_push(fallback_candidates, i);
        }
    }

    if (array_length(fallback_candidates) > 0) {
        var rand_index = fallback_candidates[irandom(array_length(fallback_candidates) - 1)];
        return rand_index;
    }

    return -1;
}
