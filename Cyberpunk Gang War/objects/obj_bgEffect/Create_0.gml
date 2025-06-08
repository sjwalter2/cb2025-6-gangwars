/// Create Event: obj_bgEffect
bg_effects = [];
randomize()
// Add all effect functions to this list
array_push(bg_effects, bg_effect_snake_sim_minimal);
array_push(bg_effects, bg_effect_triangle_grid);
array_push(bg_effects, bg_effect_scroll_lines);
array_push(bg_effects, bg_effect_rotating_squares);
array_push(bg_effects, bg_effect_grid_pulse);


bg_effect_index = irandom(4);
bg_effect_played = [];
bg_effect_timer = current_time;
bg_effect_duration = 30000;
bg_effect_fade = 0;
bg_effect_fade_dir = 1;
bg_effect_color = make_color_hsv(irandom(255), (255), (255));

for (var i = 0; i < array_length(bg_effects); i++) {
    bg_effect_played[i] = false;
}

snakes = [];
snake_count = 50;
for (var i = 0; i < snake_count; i++) {
    var xx = irandom(camera_get_view_width(view_camera[0]));
    var yy = irandom(camera_get_view_height(view_camera[0]));
    var dir = choose(0, 90, 180, 270);
    array_push(snakes, {
        head: [xx, yy],
        dir: dir,
        segments: [[xx, yy]]
    });
}
depth = 20


/// Triangle Grid
function bg_effect_triangle_grid() {
    var t = current_time * 0.001;

    for (var col = 0; col < 20; col++) {
        for (var row = 0; row < 20; row++) {
            var px = col * 100 + 50;
            var py = row * 100 + 50;
            var radius = 30 + sin(t + col * 0.5 + row * 0.3) * 10;
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


/// Scrolling Horizontal Lines
function bg_effect_scroll_lines() {
    var offset = (current_time * 0.05) mod 50;

    for (var i = -30; i < camera_get_view_height(view_camera[0]) div 10; i++) {
        var y_pos = i * 10 + offset;
        draw_line_width(0, y_pos, camera_get_view_width(view_camera[0]), y_pos, 2);
    }
}


/// Rotating Squares
function bg_effect_rotating_squares() {
    var t = current_time * 0.001;

    var spacing = 120;
    var cols = ceil(camera_get_view_width(view_camera[0]) / spacing) + 1;
    var rows = ceil(camera_get_view_height(view_camera[0]) / spacing) + 1;

    for (var col = 0; col < cols; col++) {
        for (var row = 0; row < rows; row++) {
            var cx = col * spacing;
            var cy = row * spacing;
            var size = 40 + sin(t + col * 0.3 + row * 0.4) * 10;
            var rot = t + (col + row) * 0.1;

            var c = cos(rot);
            var s = sin(rot);

            var dx = [ -1, 1, 1, -1 ];
            var dy = [ -1, -1, 1, 1 ];

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




/// Grid Pulse
function bg_effect_grid_pulse() {
    var time_val = current_time * 0.001;
    var gap = 80;
    var count_w = ceil(camera_get_view_width(view_camera[0]) / gap);
    var count_h = ceil(camera_get_view_height(view_camera[0]) / gap);

    for (var col = 0; col <= count_w; col++) {
        for (var row = 0; row <= count_h; row++) {
            var center_x = col * gap;
            var center_y = row * gap;
            var radius = 2 + sin(time_val + col * 0.3 + row * 0.5) * 8;

            draw_circle(center_x, center_y, radius, false);
        }
    }
}

function bg_effect_snake_sim_minimal() {
    var view_w = camera_get_view_width(view_camera[0]);
    var view_h = camera_get_view_height(view_camera[0]);
    var spd = 500 * (delta_time / 1000000);
    var max_length = 1000;

    for (var i = 0; i < array_length(snakes); i++) {
        var s = snakes[i];
        var old_head = s.head;
        var new_x = old_head[0] + lengthdir_x(spd, s.dir);
        var new_y = old_head[1] + lengthdir_y(spd, s.dir);
        var wrapped = false;

        // Turning decision
        if (irandom(100) < 2) {
            s.dir += choose(-90, 90);
            s.dir = s.dir mod 360;
            array_push(s.segments, old_head); // only push when turning
        }

        // Screen wrap check
        if (new_x < 0) { new_x += view_w; wrapped = true; }
        else if (new_x > view_w) { new_x -= view_w; wrapped = true; }

        if (new_y < 0) { new_y += view_h; wrapped = true; }
        else if (new_y > view_h) { new_y -= view_h; wrapped = true; }

        if (wrapped) {
            array_push(s.segments, [-1, -1]);
            array_push(s.segments, [new_x, new_y]);
        }

        s.head = [new_x, new_y];

        // Remove tail segments if snake is too long
        var total = 0;
        var path = s.segments;
        var trimmed = [s.head];

        for (var j = array_length(path) - 1; j >= 0; j--) {
            var a = trimmed[0];
            var b = path[j];
            if (a[0] == -1 || b[0] == -1) {
                array_insert(trimmed, 0, b);
                continue;
            }
            var dist = point_distance(a[0], a[1], b[0], b[1]);
            if (total + dist > max_length) break;
            total += dist;
            array_insert(trimmed, 0, b);
        }

        s.segments = trimmed;

        // Drawing
        for (var j = 1; j < array_length(s.segments); j++) {
            var a = s.segments[j - 1];
            var b = s.segments[j];
            if (a[0] == -1 || b[0] == -1) continue;
            draw_line_width(a[0], a[1], b[0], b[1], 8);
        }

        snakes[i] = s;
    }
}


