// === CONFIGURATION ===
randomize();

var HEX_SIZE          = 24;
var HEX_RADIUS        = 12;
var CORE_RADIUS       = 5;
FLICKER_PERCENT   = 0;
FLICKER_MIN_TIME  = 20000;
FLICKER_MAX_TIME  = 60000;
FLICKER_TOGGLE_MIN = 100;
FLICKER_TOGGLE_MAX = 1000;
FLICKER_MIN_BLIPS = 1;
FLICKER_MAX_BLIPS = 3;


// === Camera and Zoom Setup ===
global.cam_zoom_levels = [1920, 1280, 960];
global.cam_zoom_index = 0;
global.cam_zoom_target = global.cam_zoom_levels[global.cam_zoom_index];
global.cam_zoom_current = global.cam_zoom_target;

global.cam_pos_x = room_width / 2;
global.cam_pos_y = room_height / 2;
global.cam_target_x = global.cam_pos_x;
global.cam_target_y = global.cam_pos_y;
global.cam_vel_x = 0;
global.cam_vel_y = 0;
global.drag_inertia = 0;

global.is_dragging = false;
global.drag_start_x = 0;
global.drag_start_y = 0;
global.drag_cam_start_x = 0;
global.drag_cam_start_y = 0;

draw_gui = 1;
OUTLINE_THICKNESS = 3;
GRADIENT_STEPS    = 15;
WARM_WHITE        = make_color_rgb(220, 220, 200);

// === INITIALIZE MAP STATE ===
hex_size     = HEX_SIZE;
global.hex_size = HEX_SIZE
global.offsetX = room_width/2
global.offsetY = room_height/2
hex_radius   = HEX_RADIUS;
flickering_tile_indices = [];
start_capture = 0;

global.hex_grid = [];

for (var q = -hex_radius; q <= hex_radius; q++) {
    var r1 = max(-hex_radius, -q - hex_radius);
    var r2 = min(hex_radius, -q + hex_radius);
    for (var r = r1; r <= r2; r++) {
        var dist = max(abs(q), abs(r), abs(-q - r));
        var is_core = dist <= CORE_RADIUS;
		var is_core_border = (dist == CORE_RADIUS);
		var tile_type = "outer";
		var tile_color = make_color_rgb(80, 80, 80); // outer

		if (dist == CORE_RADIUS) {
		    tile_type = "core_border";
		    tile_color = make_color_rgb(20, 20, 20); // dark red border
		} else if (dist < CORE_RADIUS) {
		    tile_type = "core";
		    tile_color = make_color_rgb(255, 255, 255); // normal core white
		}


		var tile = {
		    q: q,
		    r: r,
		    type: is_core ? "core" : "outer",
		    brightness: is_core ? random_range(0.8, 1) : random_range(0.5, .8),
		    is_flickering: false,
		    flicker_enabled: false,
		    flicker_next: 0,
		    flicker_timer: 0,
		    flicker_count: 0,
		    flicker_on: false,
		    color: tile_color,
		    flicker_target: undefined, 
		    pending_color: undefined,   
			capture_time: -1,
			pending_owner: undefined,
			owner: undefined
		};
		tile.border_dirs = [false, false, false, false, false, false];


        array_push(global.hex_grid, tile);
    }
}

// === ENABLE FLICKERING FOR SOME TILES ===
// Only outer tiles should be eligible for flicker
var flicker_eligible = [];
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    if (tile.type == "outer") {
        array_push(flicker_eligible, i);
    }
}

flicker_target = ceil(array_length(flicker_eligible) * FLICKER_PERCENT);
var chosen = ds_list_create();

while (ds_list_size(chosen) < flicker_target) {
    var index = irandom(array_length(global.hex_grid) - 1);
    if (!ds_list_find_index(chosen, index)) {
        global.hex_grid[index].flicker_enabled = true;
        global.hex_grid[index].flicker_next = current_time + irandom_range(2000, 150000);
        ds_list_add(chosen, index);
    }
}
ds_list_destroy(chosen);


global.gang_territories = [];

global.hex_lookup = ds_map_create();
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var tile = global.hex_grid[i];
    var key = string(tile.q) + "," + string(tile.r);
    ds_map_add(global.hex_lookup, scr_axial_key(tile.q, tile.r), i);
	show_debug_message("Hex lookup key: " + string(scr_axial_key(tile.q, tile.r)));

}

// === STRONGHOLD SPAWNING ===
var stronghold_target_count = 20; // Can be set dynamically later
var min_spacing = 3; // Min distance between strongholds

global.stronghold_instances = [];

function axial_distance(q1, r1, q2, r2) {
    return max(abs(q1 - q2), abs(r1 - r2), abs((-q1 - r1) - (-q2 - r2)));
}

// Step 1: Gather all valid outer tile indices
var candidate_tiles = [];
for (var i = 0; i < array_length(global.hex_grid); i++) {
    var t = global.hex_grid[i];
    if (t.type == "outer") {
        array_push(candidate_tiles, i);
    }
}

// Step 2: Randomly place strongholds with spacing constraints
var placed_stronghold_tiles = [];

repeat (stronghold_target_count) {
    var attempts = 0;
    var placed = false;

    while (attempts < 200 && !placed && array_length(candidate_tiles) > 0) {
        var rand_idx = irandom(array_length(candidate_tiles) - 1);
        var tile_index = candidate_tiles[rand_idx];
        var tile = global.hex_grid[tile_index];


		//Check for nearby strongholds
        var too_close = false;
        for (var j = 0; j < array_length(placed_stronghold_tiles); j++) {
            var other_tile = global.hex_grid[placed_stronghold_tiles[j]];
            if (axial_distance(tile.q, tile.r, other_tile.q, other_tile.r) < min_spacing) {
                too_close = true;
                break;
            }
        }

        if (!too_close) {
            var pos = scr_axial_to_pixel(tile.q, tile.r);
            var stronghold = instance_create_layer(pos.px + global.offsetX, pos.py + global.offsetY, "Instances", obj_stronghold);
            stronghold.tile_index = tile_index;
			stronghold.q = tile.q;
			stronghold.r = tile.r;
			// Mark the hex grid tile as a stronghold
			var tile_ref = global.hex_grid[tile_index];
			tile_ref.type = "stronghold";
			global.hex_grid[tile_index] = tile_ref;

            array_push(global.stronghold_instances, stronghold);
            array_push(placed_stronghold_tiles, tile_index);
            placed = true;
        }

        attempts++;
    }
}


// Step 3 === Business SPAWNING ===
var business_target_count = 25; // Can be set dynamically later
min_spacing = 3; // Min distance between businesses

global.business_instances = [];

// Step 4: Randomly place businesses with spacing constraints

var placed_business_tiles = [];

repeat (stronghold_target_count) {
    var attempts = 0;
    var placed = false;

    while (attempts < 200 && !placed && array_length(candidate_tiles) > 0) {
        var rand_idx = irandom(array_length(candidate_tiles) - 1);
        var tile_index = candidate_tiles[rand_idx];
        var tile = global.hex_grid[tile_index];

        var too_close = false;
		
		//Check for nearby businesses
        for (var j = 0; j < array_length(placed_business_tiles); j++) {
            var other_tile = global.hex_grid[placed_business_tiles[j]];
            if (axial_distance(tile.q, tile.r, other_tile.q, other_tile.r) < min_spacing) {
                too_close = true;
                break;
            }
        }
		
		//Check for nearby strongholds
        too_close = false;
        for (var j = 0; j < array_length(placed_stronghold_tiles); j++) {
            var other_tile = global.hex_grid[placed_stronghold_tiles[j]];
            if (axial_distance(tile.q, tile.r, other_tile.q, other_tile.r) < min_spacing) {
                too_close = true;
                break;
            }
        }
		

        if (!too_close) {
            var pos = scr_axial_to_pixel(tile.q, tile.r);
            var business = instance_create_layer(pos.px + global.offsetX, pos.py + global.offsetY, "Instances", obj_business);
            business.tile_index = tile_index;
			business.q = tile.q;
			business.r = tile.r;
            array_push(global.business_instances, business);
            array_push(placed_business_tiles, tile_index);
            placed = true;
        }

        attempts++;
    }
}

// === UTILITY FUNCTIONS ===
function draw_illuminated_hex(x, y, size, color) {
    var darkened_edge_color = merge_color(color, c_black, 0.4);

    for (var s = 0; s < GRADIENT_STEPS; s++) {
        var t = s / GRADIENT_STEPS;
        var fade = 1 - t;

        if (t < 1/3) {
            var blend_t = t / (1/3);
            interp_color = merge_color(color, darkened_edge_color, 1 - blend_t);
        } else if (t < 2/3) {
            interp_color = color;
        } else {
            var blend_t = ((t - 2/3) / (1/3)) * 0.2;
            interp_color = merge_color(color, WARM_WHITE, blend_t);
        }

        draw_set_color(interp_color);
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(x, y);
        for (var i = 0; i < 6; i++) {
            var angle = degtorad(60 * i - 30);
            draw_vertex(x + cos(angle) * size * fade, y + sin(angle) * size * fade);
        }
        draw_vertex(x + cos(degtorad(-30)) * size * fade, y + sin(degtorad(-30)) * size * fade);
        draw_primitive_end();
    }
}

function draw_hex_outline(cx, cy, radius, thickness) {
    var points = [];
    for (var i = 0; i < 6; i++) {
        var angle = degtorad(60 * i - 30);
        var px = cx + cos(angle) * radius;
        var py = cy + sin(angle) * radius;
        array_push(points, [px, py]);
    }

    for (var i = 0; i < 6; i++) {
        var p1 = points[i];
        var p2 = points[(i + 1) mod 6];
        draw_line_width(p1[0], p1[1], p2[0], p2[1], thickness);
    }
}

function array_contains(arr, val) {
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == val) return true;
    }
    return false;
}

// === Add Timer-Based Spreading ===
function update_gang_spread() {
    // Global failsafe: abort if no tiles left to claim
    var sole_owner = undefined;

	for (var t = 0; t < array_length(global.hex_grid); t++) {
	    var tile = global.hex_grid[t];
	    if (tile.type != "core") {
	        if (is_undefined(tile.owner)) {
	            sole_owner = undefined;
	            break; // unowned tile found — not dominated
	        }

	        if (is_undefined(sole_owner)) {
	            sole_owner = tile.owner; // first owner we see
	        } else if (tile.owner != sole_owner) {
	            sole_owner = undefined;
	            break; // different owner — not unified
	        }
	    }
	}

	if (!is_undefined(sole_owner)) {
	    start_capture = 0;
	    return; // ✅ one gang has taken over all non-core tiles
	}


    // Loop through each gang
    for (var i = 0; i < array_length(global.gang_territories); i++) {
        var g = global.gang_territories[i];
        if (array_length(g.owned) == 0 || current_time < g.cooldown) continue;

        var spread_from = g.owned[irandom(array_length(g.owned) - 1)];
        var from_tile = global.hex_grid[spread_from];

        var directions = [
            [ 1,  0], [ 0,  1], [-1,  1],
            [-1,  0], [ 0, -1], [ 1, -1]
        ];

        var viable_targets = [];

        for (var d = 0; d < 6; d++) {
            var dq = directions[d][0];
            var dr = directions[d][1];
            var nq = from_tile.q + dq;
            var nr = from_tile.r + dr;

            for (var j = 0; j < array_length(global.hex_grid); j++) {
                var tile = global.hex_grid[j];
                if (
                    tile.q == nq &&
                    tile.r == nr &&
                    tile.type != "core" &&
                    tile.owner != g.name &&
                    is_undefined(tile.pending_owner) // ✅ not already being claimed
                ) {
                    array_push(viable_targets, j);
                }
            }
        }

        if (array_length(viable_targets) > 0) {
            var new_index = viable_targets[irandom(array_length(viable_targets) - 1)];
            var tile = global.hex_grid[new_index];

            tile.flicker_enabled = true;
            tile.flicker_count = 4;
            tile.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
            tile.flicker_on = false;
            tile.pending_color = g.color;
            tile.pending_owner = g.name;

            global.hex_grid[new_index] = tile;

            array_push(g.owned, new_index);
            g.cooldown = current_time + irandom_range(2000, 8000);
            global.gang_territories[i] = g;

            return;
        }
    }
}


function update_tile_borders(index) {
    var tile = global.hex_grid[index];
    var q = tile.q;
    var r = tile.r;
    var owner = tile.owner;

    var dir_q = [1, 0, -1, -1, 0, 1];
    var dir_r = [0, 1, 1, 0, -1, -1];

    for (var d = 0; d < 6; d++) {
        var nq = q + dir_q[d];
        var nr = r + dir_r[d];

        var neighbor_index = -1;
        for (var i = 0; i < array_length(global.hex_grid); i++) {
            var t = global.hex_grid[i];
            if (t.q == nq && t.r == nr) {
                neighbor_index = i;
                break;
            }
        }

        if (neighbor_index == -1) {
            tile.border_dirs[d] = !is_undefined(owner);
        } else {
            var neighbor_owner = global.hex_grid[neighbor_index].owner;
            tile.border_dirs[d] = (owner != neighbor_owner && !is_undefined(owner));
        }
    }

    global.hex_grid[index] = tile;
}

function update_tile_borders_for_neighbors(index) {
    if (index < 0 || index >= array_length(global.hex_grid)) return;

    var tile = global.hex_grid[index];
    var q = tile.q;
    var r = tile.r;

    var dir_q = [1, 0, -1, -1, 0, 1];
    var dir_r = [0, 1, 1, 0, -1, -1];

    // Update this tile
    update_tile_borders(index);

    // Update all 6 neighbors
    for (var d = 0; d < 6; d++) {
        var nq = q + dir_q[d];
        var nr = r + dir_r[d];

        for (var i = 0; i < array_length(global.hex_grid); i++) {
            var t = global.hex_grid[i];
            if (t.q == nq && t.r == nr) {
                update_tile_borders(i);
                break;
            }
        }
    }
}

// === INIT GANG SPAWNER ===
instance_create_depth(x, y, depth, obj_gangSpawner);
