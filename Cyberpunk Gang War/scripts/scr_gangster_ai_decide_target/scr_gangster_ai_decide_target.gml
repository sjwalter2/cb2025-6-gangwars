/// @function scr_gangster_ai_decide_target(gangster)
/// @desc Determines the best tile for the gangster to capture next, avoiding conflicts with other gangsters of the same gang
/// @param gangster - the gangster instance

function scr_gangster_ai_decide_target(gangster) {
    var best_tile_index = -1;
    var best_cost = 100000;
    var best_priority = 999;
    var best_path = [];

    if (!instance_exists(gangster.owner)) exit;

    var gang_name = gangster.owner.name;
    var start_q = gangster.current_tile.q;
    var start_r = gangster.current_tile.r;

    var cost_friendly = obj_gameHandler.cost_friendly;
    var cost_unclaimed = obj_gameHandler.cost_unclaimed;
    var cost_enemy = obj_gameHandler.cost_enemy;

    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];

        if (tile.type == "core") continue;

        var is_unclaimed = is_undefined(tile.owner) || tile.owner == "";
        var is_enemy = (!is_unclaimed && tile.owner != gang_name);
        if (!(is_unclaimed || is_enemy)) continue;

        // Skip if already being targeted or occupied by same gang
        var already_targeted_or_occupied = false;
        with (obj_gangster) {
            if (id != gangster.id && owner == gangster.owner) {
                if (target_tile_index == i || (current_tile.q == tile.q && current_tile.r == tile.r)) {
                    already_targeted_or_occupied = true;
                }
            }
        }
        if (already_targeted_or_occupied) continue;

        // Get path and cost using pathfinding script
        var path_result = scr_gangster_path_to_target(gangster.current_tile, tile, gang_name);
        if (is_undefined(path_result) || !is_array(path_result) || array_length(path_result) == 0) continue;

        var total_cost = path_result[0]; // total tick cost
        var path = path_result[1];      // tile index array

        var priority = is_unclaimed ? 2 : 1; // prefer enemy over unclaimed if cost is tied

        if (
            (total_cost < best_cost) ||
            (total_cost == best_cost && priority < best_priority)
        ) {
            best_tile_index = i;
            best_cost = total_cost;
            best_priority = priority;
            best_path = path;
        }
    }

    gangster.target_tile_index = best_tile_index;
    gangster.path = best_path;
}
