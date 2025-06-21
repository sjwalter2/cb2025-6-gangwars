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
	var GANG_AI_MAX_DISTANCE = 15;
	var GANG_AI_STRONGHOLD_SOFT_CHANCE = 0.10;
	var GANG_AI_STRONGHOLD_COST_MIN = 6;
	var GANG_AI_STRONGHOLD_COST_MAX = 15;

    if (!ds_map_exists(global.hex_lookup, start_key)) return -1;

    // === STEP 1: If no strongholds, prioritize nearest unoccupied enemy stronghold ===
	var has_stronghold = false;
	for (var i = 0; i < array_length(global.hex_grid); i++) {
	    var t = global.hex_grid[i];
	    if (t.type == "stronghold" && t.owner == gang_name) {
	        has_stronghold = true;
	        break;
	    }
	}

	if (!has_stronghold) {
	    var closest_enemy_key = scr_find_closest_stronghold(gang_name, gangster.x, gangster.y, false);
	    if (!is_undefined(closest_enemy_key)) {
	        var sx = floor(closest_enemy_key / 10000) - 5000;
	        var sy = closest_enemy_key mod 10000 - 5000;

	        var path = scr_hex_a_star_path(start_q, start_r, sx, sy, gang_name);
	        if (is_array(path) && array_length(path) > 0) {
	            var tile_idx = global.hex_lookup[? closest_enemy_key];
	            return tile_idx;
	        }
	    }
	}

   // === STEP 2: Try to optionally prioritize reachable strongholds by scaled chance
	for (var i = 0; i < array_length(global.hex_grid); i++) {
	    var tile = global.hex_grid[i];
	    if (tile.type == "stronghold" && tile.owner != gang_name && ds_list_find_index(global.claimed_tile_indices, i) != -1) {
	        for (var j = 0; j < array_length(global.hex_grid); j++) {
	            var neighbor = global.hex_grid[j];
	            if (neighbor.owner == gang_name) {
	                var d = scr_axial_distance(tile.q, tile.r, neighbor.q, neighbor.r);
	                if (d == 1) {
	                    var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
	                    if (is_array(path) && array_length(path) > 0) {
	                        // Evaluate move cost
	                        var total_cost = 0;
	                        for (var p = 0; p < array_length(path); p++) {
	                            var step = global.hex_grid[path[p]];
	                            if (step.owner == gang_name) total_cost += global.cost_friendly;
	                            else if (step.owner == "") total_cost += global.cost_unclaimed;
	                            else total_cost += global.cost_enemy;
	                        }
							// Always go for it if gang has no strongholds
	                        if (!has_stronghold) 
								return i;
								
							if (ds_list_find_index(global.claimed_tile_indices, i) != -1) continue;

	                        

	                        // Soft priority chance scaling: 100% at cost ≤ min, 10% at cost ≥ max
	                        var ratio = clamp((total_cost - GANG_AI_STRONGHOLD_COST_MIN) / (GANG_AI_STRONGHOLD_COST_MAX - GANG_AI_STRONGHOLD_COST_MIN), 0, 1);
	                        var chance = 1.0 - (1.0 - GANG_AI_STRONGHOLD_SOFT_CHANCE) * ratio;

	                        if (random(1) < chance) {
	                            return i;
	                        }
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
        if (axial_dist > GANG_AI_MAX_DISTANCE) continue;
        var key = scr_axial_key(tile.q, tile.r);
		if (tile.owner == gang_name || ds_map_exists(global.tile_reservations, key)) continue;


        var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
        if (!is_array(path) || array_length(path) == 0) continue;

        if (array_length(path) <= GANG_AI_MAX_DISTANCE) {
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
            if (d == GANG_AI_MAX_DISTANCE) array_push(fallback_candidates, i);
        }
    }

    if (array_length(fallback_candidates) > 0) {
        return fallback_candidates[irandom(array_length(fallback_candidates) - 1)];
    }

    return -1;
}
