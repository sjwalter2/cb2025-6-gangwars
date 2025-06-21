/// @function scr_init_gang(gang, name, ownedTiles)
/// @description Initializes a gang and spawns gangsters on the first two owned tiles.
/// @param {instance} gang – the gang object (obj_gang)
/// @param {string} name – the gang's name
/// @param {array} ownedTiles – array of tile indices from global.hex_grid

var _gang = argument0;
var _name = argument1;
var _owned = argument2;

if (!is_array(_owned) || array_length(_owned) < 2) {
    show_debug_message("❌ scr_init_gang: _owned is not a valid tile array for " + string(_name));
    exit;
}

// === Pull tile positions BEFORE entering the with block ===
var spawn_positions = [];

for (var i = 0; i < 2; i++) {
    var tile_index = _owned[i];
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

    money = 100;
    taxRate = 0.5;

    notoriety = 0;
    gPower = 0;
    pawns = 5;
    assignedPawnsValue = 1;

    var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist","Nomad"];
    gangType = gangTypeList[irandom(array_length(gangTypeList) - 1)];

    roster = ds_list_create();

    for (var i = 0; i < 2; i++) {
        var pos = spawn_positions[i];
        var gangster = instance_create_depth(pos[0], pos[1], 0, obj_gangster);

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

        ds_list_add(roster, gangster);
    }
}
