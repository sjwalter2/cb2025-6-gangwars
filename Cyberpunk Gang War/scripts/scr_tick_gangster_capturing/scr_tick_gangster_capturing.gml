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
		show_debug_message("Capture initiate tile: " 
					+ string(capture_tile_index) + " "
				    + string(tile))
        var intervened = false;
        var intervened_used_capture = false;
        var capture_success = true;
        var intervening_gangster = noone;
		gangster.proper_capture_reset = 1;
        with (obj_gangster) {
            if (!intervened && state == "intervening" && intervene_tile.q == tile.q && intervene_tile.r == tile.r) {
				intervened = true;
				intervening_gangster = id;
				if(captures_since_resupply < global.resupply_tile_limit)
					intervened_used_capture = true;
					
					
				var my_axial = scr_pixel_to_axial(intervening_gangster.x - global.offsetX, intervening_gangster.y - global.offsetY);
				var q = my_axial.q;
				var r = my_axial.r;
			
				show_debug_message("Successful Intervene (" 
				    + string(q) + "," + string(r) + "). alert_active=" 
				    + string(intervening_gangster.alert_active) + ", alert_responding=" 
				    + string(intervening_gangster.alert_responding) + ", alert_tile_index=" 
				    + string(intervening_gangster.alert_tile_index));
				alert_active = false;
				alert_responding = false;
				alert_tile_index = -1;
			
			}
			else if (intervened && state == "intervening" && intervene_tile.q == tile.q && intervene_tile.r == tile.r)
			{
				show_debug_message("Someone Intervening Already");
				alert_active = false;
				alert_responding = false;
				alert_tile_index = -1;
				state = "idle"
				if (gangster.state == gangster.testState) 
					show_debug_message("Changed from " + gangster.testState + " to idle 13")
				proper_intervene_reset = 1;
				
			}
        }
  

        if (intervened) {
			show_debug_message("Successful Intervene 2")
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
				if (gangster.state == gangster.testState) 
					show_debug_message("Changed from " + gangster.testState + " to idle 14")
				intervening_gangster.state = "idle"
				if (intervening_gangster.state == intervening_gangster.testState) 
					show_debug_message("Changed from " + gangster.testState + " to idle 15")
                exit;
            }

            // Old automatic resolution for NPC gangs
            var fail_chance = 0
			if (intervened_used_capture)
			    fail_chance = global.intervene_fail_chance_with_capture;
            else    
				fail_chance = global.intervene_fail_chance_without_capture;

			var roll = random(1)
            if (roll <= fail_chance) {
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
			intervening_gangster.proper_intervene_reset = 1;
			intervening_gangster.intervene_tile = -1;
			gangster.captures_since_resupply = global.resupply_tile_limit
			intervening_gangster.captures_since_resupply = global.resupply_tile_limit
			intervening_gangster.test = 0;
        }
		with(obj_gangster)
		{
			if(alert_tile_index == gangster.capture_tile_index)	
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
        scr_stop_capture(gangster)
		//if (scr_check_alert_and_respond(gangster)) return;

    }
	else if(!remaining_stronghold)
	{
		if(global.hex_grid[gangster.capture_tile_index].type != "stronghold")
		{
			scr_stop_capture(gangster)
			gangster.state = "idle";
		}
	}
	
	
	gangster.lastTicks = gangster.capture_ticks_remaining
}
