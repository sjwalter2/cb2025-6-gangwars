/// @function scr_hex_a_star_path(start_q, start_r, goal_q, goal_r, gang_name)
/// @description A* pathfinding on hex grid using axial coords
/// @return Array of tile indices (from start to goal) or empty array if no path

function scr_hex_a_star_path(start_q, start_r, goal_q, goal_r, gang_name) {
    var frontier = ds_priority_create();
    var came_from = ds_map_create(); // key: "q,r", value: previous "q,r"
    var cost_so_far = ds_map_create(); // key: "q,r", value: total cost
    var came_from_dir = ds_map_create(); // key: "q,r", value: direction index (0-5)

    var start_key = string(start_q) + "," + string(start_r);
    ds_priority_add(frontier, start_key, 0);
    came_from[? start_key] = "";
    cost_so_far[? start_key] = 0;
    came_from_dir[? start_key] = -1;

    var dirs = [[1,0],[0,1],[-1,1],[-1,0],[0,-1],[1,-1]];
    var goal_found = false;

    while (!ds_priority_empty(frontier)) {
        var current_key = ds_priority_delete_min(frontier);
        var split = string_split(current_key, ",");
        var q = real(split[0]);
        var r = real(split[1]);

        if (q == goal_q && r == goal_r) {
            goal_found = true;
            break;
        }

        for (var i = 0; i < 6; i++) {
            var nq = q + dirs[i][0];
            var nr = r + dirs[i][1];
            var neighbor_key = string(nq) + "," + string(nr);

            if (!ds_map_exists(global.hex_lookup, neighbor_key)) continue;

            var idx = global.hex_lookup[? neighbor_key];
            var tile = global.hex_grid[idx];
            if (tile == undefined) continue;

            // Skip tiles blocked by gangsters
            var blocked = false;
            with (obj_gangster) {
                if (id != global.selected[| 0]) {
                    var ax = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
                    if (ax.q == nq && ax.r == nr) blocked = true;

                    if (!is_undefined(move_target)) {
                        var tgt_q = move_target.q;
                        var tgt_r = move_target.r;
                        var is_adj = max(abs(tgt_q - ax.q), abs(tgt_r - ax.r), abs((-tgt_q - tgt_r) - (-ax.q - ax.r))) <= 1;
                        if (is_adj && tgt_q == nq && tgt_r == nr) blocked = true;
                    }
                }
            }
            if (blocked) continue;

            // Determine tile movement cost
            var tile_cost = global.cost_unclaimed; // default fallback

			if (tile.owner == "") {
			    tile_cost = global.cost_unclaimed;
			}
			else if (tile.owner == gang_name) {
			    tile_cost = global.cost_friendly;
			}
			else {
			    tile_cost = global.cost_enemy;
			}


            var new_cost = cost_so_far[? current_key] + tile_cost;

            if (!ds_map_exists(cost_so_far, neighbor_key) || new_cost < cost_so_far[? neighbor_key]) {
                cost_so_far[? neighbor_key] = new_cost;

                var h = max(abs(goal_q - nq), abs(goal_r - nr), abs((-goal_q - goal_r) - (-nq - nr)));
                var priority = new_cost + h * global.cost_friendly;

                // Add a small bias to encourage wiggling
                var last_dir = came_from_dir[? current_key];
                if (last_dir != -1 && i != last_dir) {
                    priority -= 0.1; // Prefer changing direction slightly
                }

                ds_priority_add(frontier, neighbor_key, priority);
                came_from[? neighbor_key] = current_key;
                came_from_dir[? neighbor_key] = i;
            }
        }
    }

    var path = [];
    var current = string(goal_q) + "," + string(goal_r);

    if (!goal_found || !ds_map_exists(came_from, current)) {
        ds_priority_destroy(frontier);
        ds_map_destroy(came_from);
        ds_map_destroy(cost_so_far);
        ds_map_destroy(came_from_dir);
        return [];
    }

    while (current != start_key) {
        var idx = global.hex_lookup[? current];
        array_insert(path, 0, idx);
        current = came_from[? current];
    }

    ds_priority_destroy(frontier);
    ds_map_destroy(came_from);
    ds_map_destroy(cost_so_far);
    ds_map_destroy(came_from_dir);

    return path;
}
