// GANG SPAWNER - Assign gang territories to tiles
// Assumes global.hex_grid is populated

// === CONFIGURABLE SETTINGS ===
var NUM_GANGS = 15;
var GANG_MIN_SPREAD = 5;
var GANG_MAX_SPREAD = 50;
var CORE_MIN_DISTANCE = 5;
var GANG_MIN_DISTANCE_FROM_EACH_OTHER = 6;
var COLOR_VARIATION = 40;

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

// === GENERATE VARIED COLORS ===
var gang_colors = [];
for (var i = 0; i < array_length(base_colors); i++) {
    var base = base_colors[i];
    var r = clamp(color_get_red(base) + irandom_range(-COLOR_VARIATION, COLOR_VARIATION), 0, 255);
    var g = clamp(color_get_green(base) + irandom_range(-COLOR_VARIATION, COLOR_VARIATION), 0, 255);
    var b = clamp(color_get_blue(base) + irandom_range(-COLOR_VARIATION, COLOR_VARIATION), 0, 255);
    array_push(gang_colors, make_color_rgb(r, g, b));
}

// === FIND ELIGIBLE TILES (non-core, not too close to core) ===
var eligible_tiles = [];
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    if (tile.type != "core") {
        var too_close_to_core = false;

        for (var j = 0; j < array_length(global.hex_grid); j++) {
            var core_tile = global.hex_grid[j];
            if (core_tile.type == "core") {
                var dq = tile.q - core_tile.q;
                var dr = tile.r - core_tile.r;
                var dist = max(abs(dq), abs(dr), abs(-dq - dr));
                if (dist < CORE_MIN_DISTANCE) {
                    too_close_to_core = true;
                    break;
                }
            }
        }

        if (!too_close_to_core) {
            array_push(eligible_tiles, i);
        }
    }
}

// === PLACE GANGS WITH SPACING ===
var placed_gangs = [];
var placed_coords = [];

while (array_length(placed_gangs) < NUM_GANGS && array_length(eligible_tiles) > 0) {
    var candidate_index = eligible_tiles[irandom(array_length(eligible_tiles) - 1)];
    var candidate_tile = global.hex_grid[candidate_index];

    var too_close = false;
    for (var i = 0; i < array_length(placed_coords); i++) {
        var placed = placed_coords[i];
        var dq = candidate_tile.q - placed.q;
        var dr = candidate_tile.r - placed.r;
        var dist = max(abs(dq), abs(dr), abs(-dq - dr));
        if (dist < GANG_MIN_DISTANCE_FROM_EACH_OTHER) {
            too_close = true;
            break;
        }
    }

    if (!too_close) {
        array_push(placed_gangs, candidate_index);
        array_push(placed_coords, { q: candidate_tile.q, r: candidate_tile.r });
    }

    var idx = array_index_of(eligible_tiles, candidate_index);
    if (idx != -1) {
        array_delete(eligible_tiles, idx, 1);
    }
}

// Organic spreading of territory
for (var g = 0; g < array_length(placed_gangs); g++) {
    var base_index = placed_gangs[g];
    var gang_color = gang_colors[g mod array_length(gang_colors)];
    global.hex_grid[base_index].color = gang_color;

    var owned = [base_index];
    var to_expand = [base_index];
    var spread_target = irandom_range(GANG_MIN_SPREAD, GANG_MAX_SPREAD);

    while (array_length(owned) < spread_target && array_length(to_expand) > 0) {
        // Pick a random tile from current frontier
        var from_index = to_expand[irandom(array_length(to_expand) - 1)];
        var from_tile = global.hex_grid[from_index];
        var neighbors = [];

        // Check all 6 adjacent axial directions
        var directions = [
            [ 1,  0], [ 0,  1], [-1,  1],
            [-1,  0], [ 0, -1], [ 1, -1]
        ];

        for (var d = 0; d < 6; d++) {
            var dq = directions[d][0];
            var dr = directions[d][1];
            var nq = from_tile.q + dq;
            var nr = from_tile.r + dr;

            // Find the matching tile in the grid
            for (var i = 0; i < array_length(global.hex_grid); i++) {
                var tile = global.hex_grid[i];
                if (tile.q == nq && tile.r == nr && tile.type != "core" && tile.color == make_color_rgb(80, 80, 80)) {
                    array_push(neighbors, i);
                }
            }
        }

        if (array_length(neighbors) > 0) {
            var new_index = neighbors[irandom(array_length(neighbors) - 1)];
            global.hex_grid[new_index].color = gang_color;
            array_push(owned, new_index);
            array_push(to_expand, new_index);
        } else {
            // No unclaimed neighbors from this tile, remove it from frontier
            var idx = array_index_of(to_expand, from_index);
            if (idx != -1) array_delete(to_expand, idx, 1);
        }
    }
}

