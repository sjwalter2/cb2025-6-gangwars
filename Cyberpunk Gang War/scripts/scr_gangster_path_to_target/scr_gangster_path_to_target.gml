/// @function scr_gangster_path_to_target(start_tile, goal_tile, gang_name)
/// @desc A* pathfinding for hex grid using tick cost based on tile ownership
/// @returns [total_cost, path_array] or undefined if no path

function scr_gangster_path_to_target(start_tile, goal_tile, gang_name) {
    var cost_friendly = obj_gameHandler.cost_friendly;
    var cost_unclaimed = obj_gameHandler.cost_unclaimed;
    var cost_enemy = obj_gameHandler.cost_enemy;

    var allowed_tiles = scr_get_gang_pathfinding_tiles(gang_name);

    var open_list = ds_list_create();
    var open_set_map = ds_map_create();
    var open_priority = ds_map_create();
    var came_from = ds_map_create();
    var g_score = ds_map_create();

    var start_key = string(start_tile.q) + "," + string(start_tile.r);
    ds_list_add(open_list, start_key);
    ds_map_add(open_set_map, start_key, true);
    ds_map_add(g_score, start_key, 0);
    ds_map_add(open_priority, start_key, 0);

    function heuristic(a, b) {
        return scr_axial_distance(a.q, a.r, b.q, b.r);
    }

    var goal_key = string(goal_tile.q) + "," + string(goal_tile.r);

    var max_iterations = 5000;
    var iterations = 0;

    if (global.debugMode) {
        show_debug_message("Starting A* pathfinding from [" + start_key + "] to [" + goal_key + "]");
    }

    while (ds_list_size(open_list) > 0 && iterations < max_iterations) {
        iterations++;

        // Find the node in open_list with lowest priority
        var best_index = 0;
        var best_key = open_list[| 0];
        var best_priority = ds_map_find_value(open_priority, best_key);

        for (var i = 1; i < ds_list_size(open_list); i++) {
            var k = open_list[| i];
            var p = ds_map_find_value(open_priority, k);
            if (p < best_priority) {
                best_priority = p;
                best_key = k;
                best_index = i;
            }
        }

        var current_key = best_key;
        ds_list_delete(open_list, best_index);
        ds_map_delete(open_set_map, current_key);
        ds_map_delete(open_priority, current_key);

        var current_coords = string_split(current_key, ",");
        var current_q = real(current_coords[0]);
        var current_r = real(current_coords[1]);

        if (current_q == goal_tile.q && current_r == goal_tile.r) {
            var path = [];
            var key = current_key;
            var final_cost = 0;
            if (ds_map_exists(g_score, current_key)) {
                final_cost = ds_map_find_value(g_score, current_key);
            }
            while (ds_map_exists(came_from, key)) {
                var parts = string_split(key, ",");
                var q = real(parts[0]);
                var r = real(parts[1]);
                var k = string(q) + "," + string(r);
                if (ds_map_exists(global.hex_lookup, k)) {
                    var i = global.hex_lookup[? k];
                    array_insert(path, 0, i);
                }
                key = ds_map_find_value(came_from, key);
            }
            if (global.debugMode) {
                show_debug_message("Pathfinding complete in " + string(iterations) + " iterations. Final cost: " + string(final_cost));
            }
            ds_list_destroy(open_list);
            ds_map_destroy(open_set_map);
            ds_map_destroy(open_priority);
            ds_map_destroy(came_from);
            ds_map_destroy(g_score);
            ds_list_destroy(allowed_tiles);
            return [final_cost, path];
        }

        var directions = [ [1,0], [1,-1], [0,-1], [-1,0], [-1,1], [0,1] ];
        for (var d = 0; d < 6; d++) {
            var dq = directions[d][0];
            var dr = directions[d][1];
            var nq = current_q + dq;
            var nr = current_r + dr;
            var neighbor_key = string(nq) + "," + string(nr);

            if (!ds_map_exists(global.hex_lookup, neighbor_key)) continue;

            var neighbor_index = global.hex_lookup[? neighbor_key];
            if (ds_list_find_index(allowed_tiles, neighbor_index) == -1) continue;

            var neighbor_tile = global.hex_grid[neighbor_index];
            if (neighbor_tile == noone || neighbor_tile.type == "core") continue;

            var move_cost = cost_enemy;
            if (is_undefined(neighbor_tile.owner) || neighbor_tile.owner == "") move_cost = cost_unclaimed;
            else if (neighbor_tile.owner == gang_name) move_cost = cost_friendly;

            var current_g = 0;
            if (ds_map_exists(g_score, current_key)) {
                current_g = ds_map_find_value(g_score, current_key);
            }
            var tentative_g = current_g + move_cost;

            if (!ds_map_exists(g_score, neighbor_key) || tentative_g < ds_map_find_value(g_score, neighbor_key)) {
                ds_map_replace(g_score, neighbor_key, tentative_g);
                var priority = tentative_g + heuristic(neighbor_tile, goal_tile);
                ds_map_replace(open_priority, neighbor_key, priority);
                if (!ds_map_exists(open_set_map, neighbor_key)) {
                    ds_list_add(open_list, neighbor_key);
                    ds_map_add(open_set_map, neighbor_key, true);
                }
                ds_map_replace(came_from, neighbor_key, current_key);
            }
        }
    }

    if (global.debugMode) {
        show_debug_message("Pathfinding failed after " + string(iterations) + " iterations. No path found.");
    }

    ds_list_destroy(open_list);
    ds_map_destroy(open_set_map);
    ds_map_destroy(open_priority);
    ds_map_destroy(came_from);
    ds_map_destroy(g_score);
    ds_list_destroy(allowed_tiles);
    return undefined;
}
