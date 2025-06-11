// --------------------------------------------------
// EFFECT FUNCTIONS (DEFINE FIRST)
// --------------------------------------------------

function bg_effect_snake_sim_minimal() {
	
    var p = bg_effect_params[? "snake_sim"];
    var spd = p.spd * (delta_time / 1000000);
    var max_length = p.max_length;
    var line_width = p.line_width;
    var half_w = line_width * 0.5;

    for (var i = 0; i < array_length(snakes); i++) {
		if (snake_color_mode == "rainbow") {
        var hue = (i * 360 / snake_count) mod 360;
        draw_set_color(make_color_hsv(hue, 255, 255));
	    } else {
	        draw_set_color(bg_effect_color);
	    }
        var s = snakes[i];
        var old_head = s.head;
        var new_x = old_head[0] + lengthdir_x(spd, s.dir);
        var new_y = old_head[1] + lengthdir_y(spd, s.dir);

        var margin = 5 * line_width;
        var screen_left = -margin;
        var screen_top = -margin;
        var screen_right = camera_get_view_width(view_camera[0]) + margin;
        var screen_bottom = camera_get_view_height(view_camera[0]) + margin;

        var bounced = false;

        if (new_x < screen_left) { new_x = screen_left; s.dir = 0; bounced = true; }
        else if (new_x > screen_right) { new_x = screen_right; s.dir = 180; bounced = true; }

        if (new_y < screen_top) { new_y = screen_top; s.dir = 90; bounced = true; }
        else if (new_y > screen_bottom) { new_y = screen_bottom; s.dir = 270; bounced = true; }

        if (bounced) array_push(s.corners, [new_x, new_y]);

        if (irandom(100) < p.turn_chance) {
            s.dir = (s.dir + choose(-90, 90)) mod 360;
            array_push(s.corners, [new_x, new_y]);
        }

        s.head = [new_x, new_y];

        var segment_points = [s.head];
        var total_length = 0;
        var prev_point = s.head;
        var j = array_length(s.corners) - 1;

        while (j >= 0 && total_length < max_length) {
            var corner = s.corners[j];
            var segment_length = point_distance(prev_point[0], prev_point[1], corner[0], corner[1]);

            if (total_length + segment_length >= max_length) {
                var remain = max_length - total_length;
                var dir1 = point_direction(prev_point[0], prev_point[1], corner[0], corner[1]);
                array_push(segment_points, [
                    prev_point[0] + lengthdir_x(remain, dir1),
                    prev_point[1] + lengthdir_y(remain, dir1)
                ]);
                break;
            } else {
                array_push(segment_points, corner);
                total_length += segment_length;
                prev_point = corner;
            }

            j--;
        }

        for (var k = 0; k < array_length(segment_points) - 1; k++) {
            var current = segment_points[k];
            var next = segment_points[k + 1];
            var dir_to_next = point_direction(current[0], current[1], next[0], next[1]);

            var start_x = current[0] + lengthdir_x((k == 0) ? 0 : half_w, dir_to_next);
            var start_y = current[1] + lengthdir_y((k == 0) ? 0 : half_w, dir_to_next);
            var end_x = next[0] - lengthdir_x((k == array_length(segment_points) - 2) ? 0 : -half_w, dir_to_next);
            var end_y = next[1] - lengthdir_y((k == array_length(segment_points) - 2) ? 0 : -half_w, dir_to_next);

            draw_line_width(start_x, start_y, end_x, end_y, line_width);
        }

        snakes[i] = s;
    }
}

function bg_effect_triangle_grid() {
    var p = bg_effect_params[? "triangle_grid"];
    var t = current_time * 0.001;

    for (var col = 0; col < 20; col++) {
        for (var row = 0; row < 20; row++) {
            var px = col * 100 + 50;
            var py = row * 100 + 50;
            var radius = p.base_radius + sin(t * p.wave_speed + col * 0.5 + row * 0.3) * p.wave_strength;
            var ang = t + (col + row) * 0.2;

            draw_triangle(
                px + lengthdir_x(radius, ang),
                py + lengthdir_y(radius, ang),
                px + lengthdir_x(radius, ang + 120),
                py + lengthdir_y(radius, ang + 120),
                px + lengthdir_x(radius, ang + 240),
                py + lengthdir_y(radius, ang + 240),
                false
            );
        }
    }
}

function bg_effect_scroll_lines() {
    var p = bg_effect_params[? "scroll_lines"];
    var scroll_dir = p.scroll_dir;
    var spacing = p.spacing;
    var line_spd = p.line_spd;
    var width = p.line_width;

    var perp_dir = (scroll_dir + 90) mod 360;

    var view_w = camera_get_view_width(view_camera[0]);
    var view_h = camera_get_view_height(view_camera[0]);

    // Calculate vector directions
    var move_dx = lengthdir_x(1, scroll_dir);
    var move_dy = lengthdir_y(1, scroll_dir);
    var perp_dx = lengthdir_x(1, perp_dir);
    var perp_dy = lengthdir_y(1, perp_dir);

    // View center
    var cx = view_w * 0.5;
    var cy = view_h * 0.5;

    // Total offset along movement direction
    var offset = (current_time * line_spd) mod spacing;

    // Determine how far the view stretches along the perpendicular axis
    var corners = [
        [0, 0],
        [view_w, 0],
        [view_w, view_h],
        [0, view_h]
    ];

    var min_proj = 999999;
    var max_proj = -999999;

    for (var i = 0; i < 4; i++) {
        var xx = corners[i][0] - cx;
        var yy = corners[i][1] - cy;
        var proj = xx * perp_dx + yy * perp_dy;
        if (proj < min_proj) min_proj = proj;
        if (proj > max_proj) max_proj = proj;
    }

    // Add margin before/after screen
    var margin = 200;
    min_proj -= margin;
    max_proj += margin;

    var line_start = floor(min_proj / spacing) - 1;
    var line_end   = ceil(max_proj / spacing) + 1;

    for (var i = line_start; i <= line_end; i++) {
        var base_x = cx + perp_dx * (i * spacing + offset);
        var base_y = cy + perp_dy * (i * spacing + offset);

        draw_line_width(
            base_x - move_dx * 2000,
            base_y - move_dy * 2000,
            base_x + move_dx * 2000,
            base_y + move_dy * 2000,
            width
        );
    }
}



function bg_effect_rotating_squares() {
    var p = bg_effect_params[? "rotating_squares"];
    var t = current_time * 0.001;

    var cols = ceil(camera_get_view_width(view_camera[0]) / p.spacing) + 1;
    var rows = ceil(camera_get_view_height(view_camera[0]) / p.spacing) + 1;

    for (var col = 0; col < cols; col++) {
        for (var row = 0; row < rows; row++) {
            var cx = col * p.spacing;
            var cy = row * p.spacing;
            var size = p.size_base + sin(t + col * 0.3 + row * 0.4) * p.size_wave;
            var rot = t * p.rot_speed + (col + row) * 0.1;

            var c = cos(rot);
            var s = sin(rot);
            var dx = [-1, 1, 1, -1];
            var dy = [-1, -1, 1, 1];

            draw_primitive_begin(pr_trianglefan);
            for (var i = 0; i < 4; i++) {
                var x1 = dx[i] * size;
                var y1 = dy[i] * size;
                var px = cx + (x1 * c - y1 * s);
                var py = cy + (x1 * s + y1 * c);
                draw_vertex(px, py);
            }
            draw_primitive_end();
        }
    }
}

function bg_effect_grid_pulse() {
    var p = bg_effect_params[? "grid_pulse"];
    var t = current_time * 0.001;
    var gap = p.gap;

    var pulse_dir = p.pulse_dir;
    var dir_x = lengthdir_x(1, pulse_dir);
    var dir_y = lengthdir_y(1, pulse_dir);

    var view_w = camera_get_view_width(view_camera[0]);
    var view_h = camera_get_view_height(view_camera[0]);

    var cols = ceil(view_w / gap) + 2;
    var rows = ceil(view_h / gap) + 2;

    var cx = view_w * 0.5;
    var cy = view_h * 0.5;

    for (var col = -1; col < cols; col++) {
        for (var row = -1; row < rows; row++) {
            var xx = col * gap;
            var yy = row * gap;

            // Project this point onto the wave direction
            var dx = xx - cx;
            var dy = yy - cy;
            var wave_offset = (dx * dir_x + dy * dir_y) * 0.01;

            var radius = p.radius_base + sin(t + wave_offset) * p.radius_wave;
            draw_circle(xx, yy, radius, false);
        }
    }
}

// --------------------------------------------------
// PARAMETER RANDOMIZER FUNCTIONS
// --------------------------------------------------

function randomize_params_snake_sim() {
	snake_color_mode = (irandom(10) == 0) ? "rainbow" : "normal";
    return {
        spd: random_range(200, 500),
        max_length: irandom_range(100, 800),
        line_width: irandom_range(2, 10),
        turn_chance: irandom_range(4, 20)
    };
}

function randomize_params_triangle_grid() {
    return {
        base_radius: random_range(20, 40),
        wave_strength: random_range(5, 15),
        wave_speed: random_range(0.2, 0.8)
    };
}

function randomize_params_scroll_lines() {
	var lw = irandom_range(2, 5);
    return {
		line_width: lw,
        spacing: irandom_range(lw+4, 20),
        line_spd: random_range(0.005, 0.03),
		scroll_dir: 45 * irandom(7)
    };
}

function randomize_params_rotating_squares() {
    return {
        spacing: irandom_range(60, 120),
        size_base: irandom_range(20, 50),
        size_wave: irandom_range(5, 15),
        rot_speed: random_range(0.05, 0.4)
    };
}

function randomize_params_grid_pulse() {
    return {
        gap: irandom_range(50, 100),
        radius_base: random_range(1, 5),
        radius_wave: random_range(10, 25),
        pulse_dir: 45 * irandom(7)
    };
}

// --------------------------------------------------
// APPLY RANDOMIZER
// --------------------------------------------------

function randomize_effect(index) {
    switch (index) {
        case 0: ds_map_replace(bg_effect_params, "snake_sim", randomize_params_snake_sim()); break;
        case 1: ds_map_replace(bg_effect_params, "triangle_grid", randomize_params_triangle_grid()); break;
        case 2: ds_map_replace(bg_effect_params, "scroll_lines", randomize_params_scroll_lines()); break;
        case 3: ds_map_replace(bg_effect_params, "rotating_squares", randomize_params_rotating_squares()); break;
        case 4: ds_map_replace(bg_effect_params, "grid_pulse", randomize_params_grid_pulse()); break;
    }
}

// --------------------------------------------------
// MAIN INIT
// --------------------------------------------------

randomize();

bg_effects = [];
bg_effect_params = ds_map_create();
bg_effect_played = [];
bg_effect_index = irandom(4);
bg_effect_last_index = -1;
bg_effect_timer = current_time;
bg_effect_duration = 30000;
bg_effect_fade = 0;
bg_effect_fade_dir = 1;
bg_effect_color = make_color_hsv(irandom(255), 255, 255);

array_push(bg_effects, bg_effect_snake_sim_minimal);
array_push(bg_effects, bg_effect_triangle_grid);
array_push(bg_effects, bg_effect_scroll_lines);
array_push(bg_effects, bg_effect_rotating_squares);
array_push(bg_effects, bg_effect_grid_pulse);

for (var i = 0; i < array_length(bg_effects); i++) {
    bg_effect_played[i] = false;
}

snakes = [];
snake_count = 200;
snake_color_mode = "normal"; // or "rainbow"

for (var i = 0; i < snake_count; i++) {
    var xx = irandom(camera_get_view_width(view_camera[0]));
    var yy = irandom(camera_get_view_height(view_camera[0]));
    var dir = choose(0, 90, 180, 270);
    array_push(snakes, {
        head: [xx, yy],
        dir: dir,
        corners: [[xx, yy]],
        traveled: 0
    });
}

depth = 20;

randomize_effect(bg_effect_index);
