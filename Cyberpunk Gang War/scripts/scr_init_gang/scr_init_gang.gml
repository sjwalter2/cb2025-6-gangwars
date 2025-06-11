/// @function scr_init_gang(gang, name, ownedTiles)
/// @description Initializes a gang and spawns two gangsters on the starting tile.
/// @param {instance} gang – the gang object (obj_gang)
/// @param {string} name – the gang's name
/// @param {array} ownedTiles – array of tile indices from global.hex_grid

var _gang = argument0;
var _name = argument1;
var _owned = argument2;

// === Gang Initialization ===
with (_gang) {
    name = _name;
    owned = _owned;

    owner = noone;
    boss = noone;

    testPing = false;

    money = 0;
    taxRate = 0.5;

    notoriety = 0;
    gPower = 0;
    pawns = 5;
    assignedPawnsValue = 1;

    var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist","Nomad"];
    gangType = gangTypeList[irandom(array_length(gangTypeList) - 1)];

    roster = ds_list_create();

    // === Spawn two gangsters at first tile, offset by global offsets ===
    if (array_length(owned) > 0) {
        var tile_index = owned[0];
        var tile = global.hex_grid[tile_index];
        var pos = scr_axial_to_pixel(tile.q, tile.r);

        var base_px = pos.px + global.offsetX;
        var base_py = pos.py + global.offsetY;

        for (var i = 0; i < 2; i++) {
            var gangster_y = base_py + (40 * (i + 1));
            var gangster = instance_create_depth(base_px, gangster_y, 0, obj_gangster);

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

                with (obj_gameHandler) {
                    ds_list_add(tickers, gangster);
                }

                // Attach info button with offsets applied
                var info_btn = instance_create_depth(base_px + sprite_width + 18, gangster_y - 22, 0, obj_buttonInfo);
                with (info_btn) {
                    relativeX = sprite_width + 18;
                    relativeY = -22;
                    parent = gangster;
                }
            }

            ds_list_add(roster, gangster);
        }
    }
}
