/// @function scr_hex_a_star_path(start_q, start_r, goal_q, goal_r, gang_name, is_intervening_path = false)
/// @description A* pathfinding on hex grid using axial coords
/// @return Array of tile indices (from start to goal) or empty array if no path

function scr_hex_a_star_path(start_q, start_r, goal_q, goal_r, gang_name, is_intervening_path = false) {
    var frontier = ds_priority_create();
    var came_from = ds_map_create(); // key: int, value: previous key
    var cost_so_far = ds_map_create(); // key: int, value: total cost
    var came_from_dir = ds_map_create(); // key: int, value: direction index (0-5)

    var start_key = scr_axial_key(start_q, start_r);
    ds_priority_add(frontier, start_key, 0);
    came_from[? start_key] = -1;
    cost_so_far[? start_key] = 0;
    came_from_dir[? start_key] = -1;

    var dirs = [[1,0],[0,1],[-1,1],[-1,0],[0,-1],[1,-1]];
    var goal_found = false;

    while (!ds_priority_empty(frontier)) {
        var current_key = ds_priority_delete_min(frontier);
        var q = floor(current_key / 10000) - 5000;
        var r = current_key mod 10000 - 5000;

        if (q == goal_q && r == goal_r) {
            goal_found = true;
            break;
        }

        for (var i = 0; i < 6; i++) {
            var nq = q + dirs[i][0];
            var nr = r + dirs[i][1];
            var neighbor_key = scr_axial_key(nq, nr);

            if (!ds_map_exists(global.hex_lookup, neighbor_key)) continue;

            var idx = global.hex_lookup[? neighbor_key];
            var tile = global.hex_grid[idx];
            if (tile == undefined) continue;

            
			// Skip tiles blocked by gangsters or reservations, unless it's a friendly stronghold
			var is_stronghold = (tile.type == "stronghold" && tile.owner == gang_name);
			var blocked = false;
			// Claim block check
			if (ds_list_find_index(global.claimed_tile_indices, idx) != -1) {
			    blocked = true;
			}
				if (ds_map_exists(global.gangster_tile_map, neighbor_key)) {
			    var blocker_id = global.gangster_tile_map[? neighbor_key];
			    if (instance_exists(blocker_id) && blocker_id != id && !is_stronghold) {
			        blocked = true;
			    }
			}
			if (!blocked && ds_map_exists(global.tile_reservations, neighbor_key)) {
			    if (!is_stronghold) {
			        // If this is not an intervening path, then block
			        if (!is_intervening_path) {
			            blocked = true;
			        }
			    }
			}

			if (blocked) continue;



            // Determine tile movement cost
            var tile_cost;
			if (tile.owner == gang_name) {
			    tile_cost = global.cost_friendly;
			} else if (tile.owner == "") {
			    tile_cost = global.cost_unclaimed;
			} else {
			    tile_cost = global.cost_enemy;
			}


            var new_cost = cost_so_far[? current_key] + tile_cost;

            if (!ds_map_exists(cost_so_far, neighbor_key) || new_cost < cost_so_far[? neighbor_key]) {
                cost_so_far[? neighbor_key] = new_cost;

                var h = max(abs(goal_q - nq), abs(goal_r - nr), abs((-goal_q - goal_r) - (-nq - nr)));
                var priority = new_cost + h * global.cost_friendly;

                var last_dir = came_from_dir[? current_key];
                if (last_dir != -1 && i != last_dir) {
                    priority -= 0.1;
                }

                ds_priority_add(frontier, neighbor_key, priority);
                came_from[? neighbor_key] = current_key;
                came_from_dir[? neighbor_key] = i;
            }
        }
    }

    var path = [];
    var current_key = scr_axial_key(goal_q, goal_r);

    if (!goal_found || !ds_map_exists(came_from, current_key)) {
        ds_priority_destroy(frontier);
        ds_map_destroy(came_from);
        ds_map_destroy(cost_so_far);
        ds_map_destroy(came_from_dir);
        return [];
    }

    while (current_key != start_key) {
        var idx = global.hex_lookup[? current_key];
        array_insert(path, 0, idx);
        current_key = came_from[? current_key];
    }

    ds_priority_destroy(frontier);
    ds_map_destroy(came_from);
    ds_map_destroy(cost_so_far);
    ds_map_destroy(came_from_dir);

    return path;
}
