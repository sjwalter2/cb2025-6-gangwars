//TODO - make the script ONLY neutralize hexes that are adjacent to a "core" hex
function scr_quest_corify_hex(_func){
	switch _func {
		//=============================================================================================================
		case "ok":
			core_tile_blink_count += 1
			if core_tile_blink_count == 20 {
				core_tile_blink_count = 0
				core_tile_blinks_total += 1
				if(core_tile_blinks_total % 2)
				{
					core_tile.color = make_color_rgb(20, 20, 20);
				} else
				{
					core_tile.color = make_color_rgb(255, 255, 235);
				}
			}
			if(core_tile_blinks_total == 5)
			{
				core_tile.color = make_color_rgb(255, 255, 255);
				instance_destroy()
			}
			break;		
		//=============================================================================================================
		case "setup":
		core_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
		var i = 0;
		var max_tries = 100;
		var _hasStronghold = false
		while((core_tile.type != "outer" || core_tile.owner != undefined || _hasStronghold || core_tile.pending_owner != undefined) && i < max_tries)
		{
			_hasStronghold = false
			core_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
			if (variable_instance_exists(core_tile,"tile_index"))
			{
				with(obj_stronghold)
				{
					if tile_index = other.core_tile.tile_index
						_hasStronghold = true
				}
			}
		}
		if i >= max_tries
		{
			instance_destroy()
		} else {
			core_tile.type = "core"
			core_tile.color = make_color_rgb(255, 255, 255);
			core_tile.brightness = 1
			core_tile_blink_count = 0
			core_tile_blinks_total = 0
		}
		break;
	}
}