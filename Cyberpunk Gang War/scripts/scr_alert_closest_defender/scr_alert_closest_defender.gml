/// @function scr_alert_closest_defender(gangster, capture_tile_index)
/// @description Alerts the nearest gangster from the defending gang to potentially intervene in a capture.
///              Puts them in the "alerted" state; movement begins on tick.

function scr_alert_closest_defender(gangster, capture_tile_index) {
    var tile = global.hex_grid[capture_tile_index];
    var defending_gang = tile.owner;
    if (is_undefined(defending_gang) || defending_gang == "") exit;

    var capture_axial = { q: tile.q, r: tile.r };
    var is_stronghold = (tile.type == "stronghold");

    var max_capture_ticks = global.cost_enemy * 2;
    if (is_stronghold) max_capture_ticks *= 2;

    var candidates = [];

    with (obj_gangster) {
        if (owner.name == defending_gang && state != "intervening" && !is_intervening_path) {
            // Allow capturing gangsters as long as they're not targeting this exact tile
            if (state == "capturing" && capture_tile_index != other.capture_tile_index) {
                // Don't abandon other capture attempts
                continue;
            }

            var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
            var path = scr_hex_a_star_path(my_axial.q, my_axial.r, capture_axial.q, capture_axial.r, owner.name, true);


            if (is_array(path) && array_length(path) > 0) {
                var total_cost = 0;
                for (var i = 0; i < array_length(path); i++) {
                    var t = global.hex_grid[path[i]];
                    if (t.owner == owner.name) {
                        total_cost += global.cost_friendly;
                    } else if (t.owner == "") {
                        total_cost += global.cost_unclaimed;
                    } else {
                        total_cost += global.cost_enemy;
                    }
                }

                if (total_cost <= max_capture_ticks) {
                    var candidate = {
                        inst: id,
                        path: path,
                        cost: total_cost,
                        has_capture: (captures_since_resupply < global.resupply_tile_limit)
                    };
                    array_push(candidates, candidate);
                }
            }
        }
    }

    // Sort by cost ascending (closest first)
    array_sort(candidates, function(a, b) {
        return a.cost - b.cost;
    });
	var chosen = noone;
    for (var i = 0; i < array_length(candidates); i++) {
        var c = candidates[i];

        if (is_stronghold) {
			with (c.inst) {
				alerted_by = other;
			    has_followup_move = true;
			    flash_type = "intervene";
			    flash_timer = current_time + 300;

			    if (state == "moving") {
			        // Queue the alert movement for after current move ends
			        state = "moving_alerted";
					is_intervening_path = true;
			        alert_path = c.path;
			        alert_target_tile_index = capture_tile_index;
			    } else {
			        // Start moving immediately, just like idle movement
			        state = "alerted";
					is_intervening_path = true;
			        path = c.path;
			        move_path = c.path;
			        target_tile_index = capture_tile_index;

			        if (array_length(move_path) > 0) {
			            var next_tile_index = array_shift(move_path);
			            scr_gangster_start_movement(id, next_tile_index, false);
			        }
			    }
			}

            break;
        }

        // Scaled probability based on proximity and capture availability
        var proximity = 1 - (c.cost / max_capture_ticks); // 1 = close, 0 = far
        var chance = 0.3 + 0.7 * proximity;                // 0.3 to 1.0
        if (!c.has_capture) chance *= 0.5;

        if (random(1) < chance) {
			with (c.inst) {
				alerted_by = other;
			    has_followup_move = true;
			    flash_type = "intervene";
			    flash_timer = current_time + 300;

			    if (state == "moving") {
			        // Queue the alert movement for after current move ends
			        state = "moving_alerted";
					is_intervening_path = true;
			        alert_path = c.path;
			        alert_target_tile_index = capture_tile_index;
			    } else {
			        // Start moving immediately, just like idle movement
			        state = "alerted";
					is_intervening_path = true;
			        path = c.path;
			        move_path = c.path;
			        target_tile_index = capture_tile_index;

			        if (array_length(move_path) > 0) {
			            var next_tile_index = array_shift(move_path);
			            scr_gangster_start_movement(id, next_tile_index, false);
			        }
			    }
			}

            break;
        }
    }
	var oneselected = false
	with(obj_gangster)
	{
		if(!oneselected && alerted_by = other)
		{
			oneselected = true	
		}
		else if (oneselected && alerted_by = other)
		{

			state = "idle";
		    alerted_by = noone;
		    target_tile_index = -1;
		    is_intervening_path = false;
		    move_path = [];
		    has_followup_move = false;
		}
	}
	
}
