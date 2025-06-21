// scr_tick_gangster_capturing()
function scr_tick_gangster_capturing(gangster) {
    gangster.capture_ticks_remaining--;
    gangster.flash_timer = current_time + 200;
    gangster.flash_type = "capture";

    if (gangster.capture_ticks_remaining <= 0) {
        var tile = global.hex_grid[gangster.capture_tile_index];
        var intervened = false;
        var intervened_used_capture = false;
        var capture_success = true;

        with (obj_gangster) {
		    if (alerted_by == other) {
		        if (!intervened && state == "intervening") {
		            intervened = true;
		            intervened_used_capture = (captures_since_resupply < global.resupply_tile_limit);
		        }
			        state = "idle";
			        alerted_by = noone;
			        target_tile_index = -1;
					alert_target_tile_index = -1;
			        is_intervening_path = false;
			        move_path = [];
			        has_followup_move = false;

			}
		}


        if (intervened) {
            var fail_chance = intervened_used_capture
                ? global.intervene_fail_chance_with_capture
                : global.intervene_fail_chance_without_capture;
            if (random(1) < fail_chance) {
                capture_success = false;
				// Show "DEFENDED" popup over this gangster
				var popup = instance_create_layer(gangster.x, gangster.y - 24, "UI", obj_popup_text);
				popup.text = "DEFENDED";
				popup.color = c_lime;
				popup.ttl = 150; // 5 seconds at 60fps

            }
			else
			{
				// Show "CAPTURED" popup over capturing gangster
				var popup = instance_create_layer(gangster.x, gangster.y - 24, "UI", obj_popup_text);
				popup.text = "CAPTURED";
				popup.color = c_red;
				popup.ttl = 150; // 5 seconds
			}
        }

        if (capture_success) {
            scr_claim_tile(gangster.capture_tile_index, gangster.owner);
			
			

        }
		// Stop the flickering effect on the tile
		if (gangster.capture_tile_index >= 0 && gangster.capture_tile_index < array_length(global.hex_grid)) {
		    var tile1 = global.hex_grid[gangster.capture_tile_index];
		    tile1.flicker_enabled = false;
		    tile1.flicker_timer = 0;
		    tile1.flicker_next = 0;
		    tile1.flicker_on = false;
		    tile1.pending_color = c_white;
		    tile1.pending_owner = "";
		    global.hex_grid[gangster.capture_tile_index] = tile1;
		}

        gangster.capture_tile_index = -1;
        gangster.capture_ticks_remaining = 0;
        gangster.flash_timer = current_time + 300;
        gangster.flash_type = "complete";

        gangster.captures_since_resupply++;
        gangster.state = (gangster.captures_since_resupply >= global.resupply_tile_limit)
            ? "resupplying" : "idle";
    }
}
