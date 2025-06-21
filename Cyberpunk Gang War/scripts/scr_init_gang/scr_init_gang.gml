/// @function scr_init_gang(_gang, _name, _ownedTiles,_ numGangsters)
/// @description Initializes a gang and spawns gangsters on random owned tiles.
/// @param {instance} _gang – the gang object (obj_gang)
/// @param {string} _name – the gang's name
/// @param {array} _owned – array of tile indices from global.hex_grid
/// @param {int} _numGangsters – number of gangsters to spawn

function scr_init_gang(_gang, _name, _owned, _numGangsters)
{


if (!is_array(_owned) || array_length(_owned) < 1 || _numGangsters <= 0) {
    show_debug_message("❌ scr_init_gang: _owned is not a valid tile array for " + string(_name));
    exit;
}

// === Pull random tile positions BEFORE entering the with block ===
var spawn_positions = [];

for (var i = 0; i < _numGangsters; i++) {
    var tile_index = _owned[irandom(array_length(_owned) - 1)];
    var tile = global.hex_grid[tile_index];
    var pos = scr_axial_to_pixel(tile.q, tile.r);
    var px = pos.px + global.offsetX;
    var py = pos.py + global.offsetY;
    array_push(spawn_positions, [px, py]);
}

with (_gang) {
    name = _name;
    owned = _owned;

    owner = noone;
    boss = noone;

    testPing = false;

    money = 800;
    taxRate = 0.5;

    notoriety = 0;
    gPower = 0;
    pawns = 5;
    assignedPawnsValue = 1;

    var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist","Nomad"];
    gangType = gangTypeList[irandom(array_length(gangTypeList) - 1)];

    roster = ds_list_create();

    for (var i = 0; i < array_length(spawn_positions); i++) {
        var pos = spawn_positions[i];
        var gangster = instance_create_layer(pos[0], pos[1], "Instances", obj_gangster);

        with (gangster) {
            owner = _gang;
			myGang = _name
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

        ds_list_add(roster, gangster);
    }
}
}