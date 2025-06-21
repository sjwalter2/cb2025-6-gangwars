/// @function scr_hire_gangster(_gang)
/// @description Hires a ganster at an owned stronghold
/// @param {instance} _gang - the gang object (obj_gang)
function scr_hire_gangster(_gang){
	//Choose a spawn location
	var _success = false
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type == "stronghold" && tile.owner == _gang.name) {
			_success = true
			break;
        }
    }
	if(!_success){
		show_debug_message("No owned strongholds! :(");
		return 0;
	}
	var pos = scr_axial_to_pixel(tile.q, tile.r);
    var px = pos.px + global.offsetX;
    var py = pos.py + global.offsetY;
	var gangster = instance_create_depth(px,py, 0, obj_gangster)
	with (gangster) {
		owner = _gang;
        name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"), ord("Z")));
        sprite_head_index = irandom(sprite_get_number(spr_gangsterHead) - 1);
        image_blend = make_color_rgb(irandom(255), irandom(255), irandom(255));
        displayStatsFull = false;
        money = 0;
        taxRate = 0.1;
        boss = noone;
        var seed = scr_hash_string(name);
        random_set_seed(seed);
        charisma = irandom(5);
        might = irandom(5);
        honor = irandom(5);
        randomize();
    }
    ds_list_add(_gang.roster, gangster);
	return gangster;
}