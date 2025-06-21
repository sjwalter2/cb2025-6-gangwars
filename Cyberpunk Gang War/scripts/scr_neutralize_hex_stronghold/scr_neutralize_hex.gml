// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_neutralize_hex(_func){
	switch _func {
		//=============================================================================================================
		case "ok":
			core_tile_blink_count += 1
			if core_tile_blink_count == 30 {
				core_tile_blink_count = 0
				core_tile_blinks_total += 1
				if(core_tile_blinks_total % 2)
				{
					core_tile.color = make_color_rgb(20, 20, 20);
				} else
				{
					core_tile.color = make_color_rgb(180, 180, 160);
				}
			}
			if(core_tile_blinks_total == 5)
			{
				core_tile.color = make_color_rgb(80, 80, 80);
				instance_destroy()
			}
			break;		
		//=============================================================================================================
		case "setup":
		core_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
		var i = 0;
		var max_tries = 100;
		while(core_tile.type != "core" && i < max_tries)
		{
			core_tile = global.hex_grid[irandom(array_length(global.hex_grid)-1)];
		}
		if i >= max_tries
		{
			instance_destroy()
		} else {
			core_tile.type = "outer"
			core_tile.color = make_color_rgb(180, 180, 160);
			core_tile_blink_count = 0
			core_tile_blinks_total = 0
		}
		break;
	}
}