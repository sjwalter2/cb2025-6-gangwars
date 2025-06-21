function scr_tick_gangster_capturing(gangster) {
	// === Alert defenders if not already sent ===
    if (!gangster.alert_sent) {
        gangster.alert_sent = true;
        scr_alert_gang_for_intervention(gangster.capture_tile_index, gangster.id);
    }
    gangster.capture_ticks_remaining--;
    gangster.flash_timer = current_time + 200;
    gangster.flash_type = "capture";


    if (gangster.capture_ticks_remaining <= 0) {
		gangster.alert_sent = false;
        var tile = global.hex_grid[gangster.capture_tile_index];
        var intervened = false;
        var intervened_used_capture = false;
        var capture_success = true;
        var intervening_gangster = noone;

        with (obj_gangster) {
            if (!intervened && state == "intervening" && global.hex_grid[alert_tile_index] == tile) {
				intervened = true;
				intervening_gangster = id;
				if(captures_since_resupply < global.resupply_tile_limit)
					intervened_used_capture = true;
				alert_active = false;
				alert_responding = false;
				alert_tile_index = -1;
			
			}
			else if (intervened && state == "intervening" && global.hex_grid[alert_tile_index] == tile)
			{
				alert_active = false;
				alert_responding = false;
				alert_tile_index = -1;
				state = "idle"
				
			}
        }
  

        if (intervened) {
            if (!gangster.owner.autonomous && gangster.owner.autonomous) {
                // Queue battle instead of resolving
                global.currentSpeedBeforeBattle = global.currentSpeed;
				with(obj_gameHandler)
					nextSpeed = 0;

                array_push(global.pendingBattles, {
                    attacker: gangster,
                    defender: intervening_gangster,
                    tile_index: gangster.capture_tile_index
                });

                if (array_length(global.pendingBattles) == 1) {
                    instance_create_layer(320, 240, "UI", obj_battleChoiceWindow);
                }

                // Exit for now — battle resolution will handle outcome
				gangster.state = "idle"
				intervening_gangster.state = "idle"
                exit;
            }

            // Old automatic resolution for NPC gangs
            var fail_chance = intervened_used_capture
                ? global.intervene_fail_chance_with_capture
                : global.intervene_fail_chance_without_capture;

            if (random(1) < fail_chance) {
                capture_success = false;

                var popup = instance_create_layer(gangster.x, gangster.y - 24, "UI", obj_popup_text);
                popup.text = "DEFENDED";
                popup.color = c_lime;
                popup.ttl = 150;
            } else {
                var popup = instance_create_layer(gangster.x, gangster.y - 24, "UI", obj_popup_text);
                popup.text = "CAPTURED";
                popup.color = c_red;
                popup.ttl = 150;
            }
			gangster.state = "resupplying"
			intervening_gangster.state = "resupplying"
			gangster.captures_since_resupply = global.resupply_tile_limit
			intervening_gangster.captures_since_resupply = global.resupply_tile_limit
			intervening_gangster.test = 0;
        }
		with(obj_gangster)
		{
			if(alert_tile_index = gangster.capture_tile_index)	
			{
				alert_tile_index = -1
				alert_responding = false
				alert_active = false
			}
		}
		

        if (capture_success) {
            scr_claim_tile(gangster.capture_tile_index, gangster.owner);
        }

        // Stop flicker
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

        gangster.state = (gangster.captures_since_resupply >= global.resupply_tile_limit)
            ? "resupplying" : "idle";
			
		//if (scr_check_alert_and_respond(gangster)) return;

    }
}
