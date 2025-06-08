// === CONFIGURATION ===
random_set_seed(irandom(199));

var HEX_SIZE          = 16;
var HEX_RADIUS        = 16;
var CORE_RADIUS       = 5;
FLICKER_PERCENT   = 0.1;
FLICKER_MIN_TIME  = 20000;
FLICKER_MAX_TIME  = 60000;
FLICKER_TOGGLE_MIN = 100;
FLICKER_TOGGLE_MAX = 1000;
FLICKER_MIN_BLIPS = 1;
FLICKER_MAX_BLIPS = 3;

var ZOOM_LEVEL_INIT   = 0;
var ZOOM_LEVEL_MAX    = 2;

var OUTLINE_THICKNESS = 2;
GRADIENT_STEPS    = 15;
WARM_WHITE        = make_color_rgb(220, 220, 200);

// === INITIALIZE MAP STATE ===
hex_size     = HEX_SIZE;
hex_radius   = HEX_RADIUS;
zoom_level   = ZOOM_LEVEL_INIT;
zoom_max     = ZOOM_LEVEL_MAX;
flickering_tile_indices = [];

global.hex_grid = [];

for (var q = -hex_radius; q <= hex_radius; q++) {
    var r1 = max(-hex_radius, -q - hex_radius);
    var r2 = min(hex_radius, -q + hex_radius);
    for (var r = r1; r <= r2; r++) {
        var dist = max(abs(q), abs(r), abs(-q - r));
        var is_core = dist <= CORE_RADIUS;

        var tile = {
            q: q,
            r: r,
            type: is_core ? "core" : "outer",
            brightness: random_range(0.5, 1.0),
            is_flickering: false,
            flicker_enabled: false,
            flicker_next: 0,
            flicker_timer: 0,
            flicker_count: 0,
            flicker_on: false,
            color: is_core ? make_color_rgb(255, 255, 255) : make_color_rgb(80, 80, 80)
        };

        array_push(global.hex_grid, tile);
    }
}

// === ENABLE FLICKERING FOR SOME TILES ===
var flicker_target = ceil(array_length(global.hex_grid) * FLICKER_PERCENT);
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

// === UTILITY FUNCTIONS ===
function axial_to_pixel(q, r) {
    var spacing = 1.1;
    var px = spacing * hex_size * sqrt(3) * (q + r / 2);
    var py = spacing * hex_size * 3/2 * r;
    return {px: px, py: py};
}

function draw_illuminated_hex(x, y, size, color) {
    var darkened_edge_color = merge_color(color, c_black, 0.4);

    for (var s = 0; s < GRADIENT_STEPS; s++) {
        var t = s / GRADIENT_STEPS;
        var fade = 1 - t;

        var interp_color;
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

// === INIT GANG SPAWNER ===
instance_create_depth(x, y, depth, obj_gangSpawner);
