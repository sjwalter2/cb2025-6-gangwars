
function scr_neutralize_hex_stronghold(_func){
	switch _func {
		//=============================================================================================================
		case "setup":
			core_tile_index = irandom(array_length(global.hex_grid)-1)
			core_tile = global.hex_grid[core_tile_index];
			var i = 0;
			var max_tries = 100;
			while(core_tile.type != "core" && i < max_tries)
			{
				core_tile_index = irandom(array_length(global.hex_grid)-1)
				core_tile = global.hex_grid[core_tile_index];
			}
			if i >= max_tries
			{
				instance_destroy()
			} else {
				core_tile.type = "outer"
				core_tile.color = make_color_rgb(180, 180, 160);
				core_tile_blink_count = 0
				core_tile_blinks_total = 0
				name_set = false
			
			}
			func = "confirm"
			break;		
		//=============================================================================================================
		default:
			if(!name_set)
			{
				with(obj_map)
				{
					var pos = scr_axial_to_pixel(other.core_tile.q, other.core_tile.r);
					var stronghold = instance_create_layer(pos.px + global.offsetX, pos.py + global.offsetY, "Instances", obj_stronghold);
					stronghold.tile_index = other.core_tile_index;
					stronghold.q = other.core_tile.q;
					stronghold.r = other.core_tile.r;
				
					//Remove the name from global names list and add the name from the quest
					//Technically this *could* remove the wrong name if somehow 2 strongholds are created in the same step but I highly doubt it
					//Famous last words
					array_pop(global.used_stronghold_names)
					stronghold.name = other.func
				
				
					// Mark the hex grid tile as a stronghold
					var tile_ref = global.hex_grid[other.core_tile_index];
					tile_ref.type = "stronghold";
					global.hex_grid[other.core_tile_index] = tile_ref;

					array_push(global.stronghold_instances, stronghold);
				}
				name_set = true
			}
						
			core_tile_blink_count += 1
			if core_tile_blink_count == 20 {
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
	}
}