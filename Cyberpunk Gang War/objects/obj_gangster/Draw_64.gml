var is_hovered = false;

// === View and GUI scaling
var cam = view_camera[0];
var view_x = camera_get_view_x(cam);
var view_y = camera_get_view_y(cam);
var view_w = camera_get_view_width(cam);
var view_h = camera_get_view_height(cam);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var scale_x = view_w / gui_w;
var scale_y = view_h / gui_h;

// === Mouse and gangster positions
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);
var gangster_gui = scr_world_to_gui(x, y);

// === Hover detection
if (abs(mouse_gui_x - gangster_gui.x) < gangsterWidth * 0.5 &&
    abs(mouse_gui_y - gangster_gui.y) < gangsterHeight * 0.5) {
    is_hovered = true;
}

// === Tooltip condition
if (is_hovered || (ds_exists(global.selected, ds_type_list) && ds_list_find_index(global.selected, self) != -1)) {

    // === Gang data
    var gang_name = "Unknown Gang";
    var gang_color = c_gray;
    if (instance_exists(owner)) {
        if (variable_instance_exists(owner, "name")) gang_name = owner.name;
        if (variable_instance_exists(owner, "color")) gang_color = owner.color;
    }

    // === Text and box dimensions
    var tooltip_text_1 = name;
    var tooltip_text_2 = gang_name;

    var padding = 8;
    var spacing = 6;

    var text_width = max(string_width(tooltip_text_1), string_width(tooltip_text_2));
    var box_width = text_width + padding * 2;
    var box_height = string_height(tooltip_text_1) + string_height(tooltip_text_2) + spacing + padding * 2;

    var offset = 24;
    var gui_x = gangster_gui.x;
    var gui_y = gangster_gui.y;

    // === Placement options
    var placements = [
        { x: gui_x - box_width / 2, y: gui_y - offset - box_height },
        { x: gui_x - box_width / 2, y: gui_y + offset },
        { x: gui_x + offset, y: gui_y - box_height / 2 },
        { x: gui_x - box_width - offset, y: gui_y - box_height / 2 }
    ];

    var best_score = 999999;
    var best_x = gui_x;
    var best_y = gui_y;

    // Secondary fallback if no good position is found
    var fallback_dist = 999999;
    var fallback_x = best_x;
    var fallback_y = best_y;

    for (var i = 0; i < array_length(placements); i++) {
        var pos = placements[i];
        var bx = pos.x;
        var by = pos.y;
        var scoreVal = 0;

        var offscreen = bx < 0 || by < 0 || bx + box_width > gui_w || by + box_height > gui_h;
        if (offscreen) scoreVal += 1000;

        var overlaps_mouse = mouse_gui_x > bx && mouse_gui_x < bx + box_width &&
                             mouse_gui_y > by && mouse_gui_y < by + box_height;
        if (overlaps_mouse) scoreVal += 100;

        var overlaps_tooltip = false;
        for (var j = 0; j < array_length(global.tooltip_boxes_drawn); j++) {
            var prev = global.tooltip_boxes_drawn[j];
            if (bx < prev.x + prev.w && bx + box_width > prev.x &&
                by < prev.y + prev.h && by + box_height > prev.y) {
                overlaps_tooltip = true;
                scoreVal += 1;
            }
        }

        if (scoreVal < best_score) {
            best_score = scoreVal;
            best_x = bx;
            best_y = by;
        }

        // If everything is bad, track the least *distance* from hover center as fallback
        if (offscreen || overlaps_mouse || overlaps_tooltip) {
            var dx = (bx + box_width / 2) - gangster_gui.x;
            var dy = (by + box_height / 2) - gangster_gui.y;
            var dist = dx * dx + dy * dy;

            if (dist < fallback_dist) {
                fallback_dist = dist;
                fallback_x = bx;
                fallback_y = by;
            }
        }
    }

    // If all placements are bad, use fallback
    if (best_score >= 1000 + 100 + 1) {
        best_x = fallback_x;
        best_y = fallback_y;
    }

    // Register for collision tracking
    array_push(global.tooltip_boxes_drawn, {
        x: best_x,
        y: best_y,
        w: box_width,
        h: box_height
    });

    // === Draw tooltip
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_roundrect(best_x, best_y, best_x + box_width, best_y + box_height, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(scr_get_gang_color(owner.name));
    draw_text(best_x + box_width / 2, best_y + padding, tooltip_text_1);
    draw_text(best_x + box_width / 2, best_y + padding + string_height(tooltip_text_1) + spacing, tooltip_text_2);
}
