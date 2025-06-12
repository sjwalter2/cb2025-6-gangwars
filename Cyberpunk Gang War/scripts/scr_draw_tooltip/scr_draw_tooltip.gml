// === Gangster and Tile Tooltip Handler ===

/// @function scr_draw_tooltip
/// @param text1 - Primary tooltip text
/// @param text2 - Secondary tooltip text
/// @param world_x - World x position to anchor tooltip
/// @param world_y - World y position to anchor tooltip
/// @param exclude_tiles - (optional) ds_list of axial "q,r" keys that tooltip should avoid drawing on
/// @param text_color - (optional) color for the text, defaults to c_white

function scr_draw_tooltip(text1, text2, world_x, world_y, exclude_tiles = undefined, text_color = c_white) {
    var gui_pos = scr_world_to_gui(world_x, world_y);
    var gui_x = gui_pos.x;
    var gui_y = gui_pos.y;

    var cam = view_camera[0];
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var padding = 8;
    var spacing = 6;

    var box_width = max(string_width(text1), string_width(text2)) + padding * 2;
    var box_height = string_height(text1) + string_height(text2) + spacing + padding * 2;

    var placements = [
        { x: gui_x - box_width / 2, y: gui_y - 24 - box_height },
        { x: gui_x - box_width / 2, y: gui_y + 24 },
        { x: gui_x + 24, y: gui_y - box_height / 2 },
        { x: gui_x - box_width - 24, y: gui_y - box_height / 2 }
    ];

    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    var best_score_val = 999999;
    var best_x = gui_x;
    var best_y = gui_y;
    var fallback_dist = 999999;
    var fallback_x = best_x;
    var fallback_y = best_y;

    for (var i = 0; i < array_length(placements); i++) {
        var bx = placements[i].x;
        var by = placements[i].y;
        var placement_score = 0;

        if (bx < 0 || by < 0 || bx + box_width > gui_w || by + box_height > gui_h) placement_score += 1000;
        if (mouse_gui_x > bx && mouse_gui_x < bx + box_width && mouse_gui_y > by && mouse_gui_y < by + box_height) placement_score += 100;

        for (var j = 0; j < array_length(global.tooltip_boxes_drawn); j++) {
            var prev = global.tooltip_boxes_drawn[j];
            if (bx < prev.x + prev.w && bx + box_width > prev.x &&
                by < prev.y + prev.h && by + box_height > prev.y) {
                placement_score += 1;
            }
        }

        if (exclude_tiles != undefined) {
            var gui_tile = scr_gui_to_world(bx + box_width / 2, by + box_height / 2);
            var tile_axial = scr_pixel_to_axial(gui_tile.x - global.offsetX, gui_tile.y - global.offsetY);
            var key = string(tile_axial.q) + "," + string(tile_axial.r);
            if (ds_list_find_index(exclude_tiles, key) != -1) placement_score += 500;
        }

        if (placement_score < best_score_val) {
            best_score_val = placement_score;
            best_x = bx;
            best_y = by;
        }

        var dx = (bx + box_width / 2) - gui_x;
        var dy = (by + box_height / 2) - gui_y;
        var dist = dx * dx + dy * dy;

        if (dist < fallback_dist) {
            fallback_dist = dist;
            fallback_x = bx;
            fallback_y = by;
        }
    }

    if (best_score_val >= 1101) {
        best_x = fallback_x;
        best_y = fallback_y;
    }

    array_push(global.tooltip_boxes_drawn, { x: best_x, y: best_y, w: box_width, h: box_height });

    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_roundrect(best_x, best_y, best_x + box_width, best_y + box_height, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(text_color);
    draw_text(best_x + box_width / 2, best_y + padding, text1);
    draw_text(best_x + box_width / 2, best_y + padding + string_height(text1) + spacing, text2);
}
