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

    var has_stronghold = gangster.remaining_stronghold;

    // === STEP 1: Get all valid targets early ===
    var targets = scr_get_targetable_tiles(gang_name);
    if (ds_list_size(targets) == 0) {
        ds_list_destroy(targets);
        return -1;
    }

    // === STEP 2: Prioritize strongholds from within targetable tiles ===
    for (var i = 0; i < ds_list_size(targets); i++) {
        var tile_index = targets[| i];
        var tile = global.hex_grid[tile_index];

        if (tile.type == "stronghold" && tile.owner != gang_name) {
            var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
            if (!is_array(path) || array_length(path) == 0) continue;

            var total_cost = 0;
            for (var p = 0; p < array_length(path); p++) {
                var step = global.hex_grid[path[p]];
                if (step.owner == gang_name) total_cost += global.cost_friendly;
                else if (step.owner == "") total_cost += global.cost_unclaimed;
                else total_cost += global.cost_enemy;
            }

            if (!has_stronghold) {
                ds_list_destroy(targets);
                return tile_index;
            }

            var ratio = clamp((total_cost - GANG_AI_STRONGHOLD_COST_MIN) / (GANG_AI_STRONGHOLD_COST_MAX - GANG_AI_STRONGHOLD_COST_MIN), 0, 1);
            var chance = 1.0 - (1.0 - GANG_AI_STRONGHOLD_SOFT_CHANCE) * ratio;

            if (random(1) < chance) {
                ds_list_destroy(targets);
                return tile_index;
            }
        }
    }

    // === STEP 3: Standard targetable tile evaluation ===
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

    // === STEP 4: If no strongholds and none found in reachable tiles, search all strongholds for nearest viable ===
    if (!has_stronghold) {
        var best_dist = 100000;
        for (var i = 0; i < array_length(global.hex_grid); i++) {
            var tile = global.hex_grid[i];
            if (tile.type == "stronghold" && tile.owner != gang_name && ds_list_find_index(global.claimed_tile_indices, i) == -1) {
                var path = scr_hex_a_star_path(start_q, start_r, tile.q, tile.r, gang_name);
                if (!is_array(path) || array_length(path) == 0) continue;
                if (array_length(path) < best_dist) {
                    best_dist = array_length(path);
                    best_tile_index = i;
                }
            }
        }

        if (best_tile_index != -1) return best_tile_index;
    }

    return -1;
}
