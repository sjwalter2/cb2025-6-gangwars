// GANG SPAWNER - Assign gang territories to tiles
// Assumes global.hex_grid is populated

// === CONFIGURABLE SETTINGS ===
var NUM_GANGS = 10;
var NUM_GANGSTERS = 2;
var GANG_MIN_SPREAD = 10;
var GANG_MAX_SPREAD = 15;
var CORE_MIN_DISTANCE = 5;
var GANG_MIN_DISTANCE_FROM_EACH_OTHER = 6;
var COLOR_VARIATION = 100;



global.gangadjectives = scr_generate_names("gangfirstnames.txt")
global.gangnouns = scr_generate_names("ganglastnames.txt")

// === HELPER ===
function array_index_of(arr, val) {
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == val) return i;
    }
    return -1;
}

// === BASE COLORS (core red excluded) ===
var base_colors = [
    make_color_rgb(60, 180, 255),   // blue
    make_color_rgb(255, 180, 40),   // orange
    make_color_rgb(120, 255, 120),  // green
    make_color_rgb(255, 60, 200),   // pink
    make_color_rgb(160, 120, 255),  // purple
    make_color_rgb(255, 255, 100),  // yellow
    make_color_rgb(100, 255, 200),  // teal
    make_color_rgb(255, 100, 100),  // light red
    make_color_rgb(150, 255, 50),   // lime
    make_color_rgb(200, 100, 255)   // violet
];

// === GENERATE HUE-BASED GANG COLORS ===
var gang_colors = [];
var hue_step = floor(255 / (NUM_GANGS+1)); // Spread hues evenly across 0-255


for (var i = 0; i < NUM_GANGS; i++) {
    var hue = i * (hue_step - hue_step/8 + irandom(hue_step/4));
    
    var sat = clamp(255 - irandom_range(0, COLOR_VARIATION), 0, 255);
    var val = clamp(255 - irandom_range(0, COLOR_VARIATION), 0, 255);

    var gang_color = make_color_hsv(hue, sat, val);
    array_push(gang_colors, gang_color);
}

// === FILTER VALID STRONGHOLDS ===
var available_strongholds = [];
for (var i = 0; i < array_length(global.stronghold_instances); i++) {
    var sh = global.stronghold_instances[i];
    var tile = global.hex_grid[sh.tile_index];
    if (is_undefined(tile.owner)) {
        array_push(available_strongholds, sh);
    }
}

// Limit to number of gangs
NUM_GANGS = min(NUM_GANGS, array_length(available_strongholds));

// === SPAWN GANGS FROM VALID STRONGHOLDS ===
for (var g = 0; g < NUM_GANGS; g++) {
    var stronghold = available_strongholds[g];
    var base_index = stronghold.tile_index;
    var base_tile = global.hex_grid[base_index];

    if (!variable_global_exists("used_gang_names")) global.used_gang_names = [];

    var gang_name = "";
    repeat (100) {
        var adj = scr_get_name(global.gangadjectives);
        var noun = scr_get_name(global.gangnouns);
        var try_name = "The " + adj + " " + noun;

        if (!array_contains(global.used_gang_names, try_name)) {
            gang_name = try_name;
            array_push(global.used_gang_names, try_name);
            break;
        }
    }

    var gang_color = gang_colors[g mod array_length(gang_colors)];
    base_tile.owner = gang_name;
    base_tile.color = gang_color;
    global.hex_grid[base_index] = base_tile;

    stronghold.owner = gang_name;

    var owned = [base_index];

    array_push(global.gang_territories, {
        name: gang_name,
        color: gang_color,
		strongholds: [],
        owned: owned,
        cooldown: current_time + irandom_range(2000, 8000)
    });
}

// === EXPAND EACH GANG ONE TILE AT A TIME ===
var any_can_expand = true;

while (any_can_expand) {
    any_can_expand = false;

    for (var g = 0; g < array_length(global.gang_territories); g++) {
        var gang = global.gang_territories[g];
        var target_size = irandom_range(GANG_MIN_SPREAD, GANG_MAX_SPREAD);
        if (array_length(gang.owned) >= target_size) continue;

        var neighbors = [];

        for (var i = 0; i < array_length(gang.owned); i++) {
            var index = gang.owned[i];
            var tile = global.hex_grid[index];

            var directions = [
                [ 1,  0], [ 0,  1], [-1,  1],
                [-1,  0], [ 0, -1], [ 1, -1]
            ];

            for (var d = 0; d < 6; d++) {
                var nq = tile.q + directions[d][0];
                var nr = tile.r + directions[d][1];

                for (var j = 0; j < array_length(global.hex_grid); j++) {
                    var t = global.hex_grid[j];
                    if (t.q == nq && t.r == nr && t.type != "core" && is_undefined(t.owner)) {
                        array_push(neighbors, j);
                    }
                }
            }
        }

        if (array_length(neighbors) > 0) {
            var new_index = neighbors[irandom(array_length(neighbors) - 1)];
            global.hex_grid[new_index].owner = gang.name;
            global.hex_grid[new_index].color = gang.color;
            array_push(gang.owned, new_index);
            global.gang_territories[g] = gang;
            any_can_expand = true;
        }
    }
}

	
// === SPAWN ONE obj_gang FOR EACH GANG TERRITORY (UI ELEMENT) ===
var ui_base_x = room_width - 10;
var ui_base_y = 10;
var ui_spacing = 110;

//Since gang color order seems to be static for now, I'm making the player gang random
//That way you dont always play as the same gang ;P
var _random_gang_becomes_player_gang = irandom(array_length(global.gang_territories)-1)

for (var i = 0; i < array_length(global.gang_territories); i++) {
    var gang = global.gang_territories[i];
    var y_offset = ui_base_y + (i * ui_spacing);

    var new_gang = instance_create_layer(ui_base_x, y_offset, "UI", obj_gang);
	new_gang.name = gang.name;
	new_gang.owned = gang.owned;
	scr_init_gang(new_gang, gang.name, gang.owned, NUM_GANGSTERS);
	if i == _random_gang_becomes_player_gang {
		new_gang.autonomous = false
	}
}



// === FINALIZE BORDER STATE FOR ALL OWNED TILES ===
with(obj_map)
{
	for (var i = 0; i < array_length(global.hex_grid); i++) {
	    if (!is_undefined(global.hex_grid[i].owner)) {
	        update_tile_borders_for_neighbors(i);
	    }
	}
}

