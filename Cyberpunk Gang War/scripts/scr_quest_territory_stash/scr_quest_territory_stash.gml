function scr_quest_territory_stash(_func){
	switch _func {
		//=============================================================================================================
		case "ok":
			if(outer_tile.owner == playerGang.name)
			{
				func = "confirm"
				var _gainMoney = irandom_range(100,600)
				description = gangster.name + " was right. There's gotta be $" + string(_gainMoney) + " worth of Hex here! Ours for the taking."
				with playerGang
				{
					scr_gain_money(_gainMoney)
				}
				displayReady = true
				with instance_create_layer(_width*0.5,_height*0.666,"questButtons",obj_buttonQuest)
				{
					parent = other
					myFunction = "end"
					text = "Primo stuff"
					shelfActive = true
					guiX = x
					guiY = y
				}
				outer_tile.brightness = oldBrightness
			} else {
				outer_tile_blink_count += 1
				if outer_tile_blink_count == 20 {
					outer_tile_blink_count = 0
					outer_tile_blinks_total += 1
					if(outer_tile_blinks_total % 2)
					{
						outer_tile.color = oldColor;
					} else
					{
						outer_tile.color = make_color_rgb(220, 220, 20);
					}
				}
			}
			
			break;		
		//=============================================================================================================
		case "setup":
			if(playerGang == noone)
			{
				show_debug_message("WARNING: Couldn't find player gang");
				instance_destroy();
				exit;
			}
			gangster = noone
			gangster = ds_list_find_value(playerGang.roster,irandom(ds_list_size(playerGang.roster)-1));
			if(gangster == noone){
				show_debug_message("WARNING: Couldnt find a gangster in scr_quest_territory_stash")
				description = string_replace(description, "$GANGSTER" , "Jay T. Doggzone");
			} else {
				description = string_replace(description, "$GANGSTER" , gangster.name);
			}
		
			outer_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
			var i = 0;
			var max_tries = 200;
			while((outer_tile.type != "outer" || outer_tile.owner == playerGang.name) && i < max_tries)
			{
				outer_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
			}
			if i >= max_tries
			{
				instance_destroy();
				exit;
			} else {
				oldColor = outer_tile.color
				outer_tile.color = make_color_rgb(220, 220, 20);
				oldBrightness = outer_tile.brightness
				outer_tile.brightness = 1
				outer_tile_blink_count = 0
				outer_tile_blinks_total = 0
			}
			break;
		//=============================================================================================================
		case "end":
			instance_destroy()
			break;
	}
}