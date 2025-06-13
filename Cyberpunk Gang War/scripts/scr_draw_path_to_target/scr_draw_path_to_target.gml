/// @function scr_draw_path_to_target()
/// @description Draws a preview path using A* from selected gangster to hovered tile. If unreachable, draws red indicator only.

function scr_draw_path_to_target() {
    if (ds_list_find_index(global.selected, self) == -1) exit;

    var mouse_axial = scr_pixel_to_axial(mouse_x - global.offsetX, mouse_y - global.offsetY);
    var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);

    // Recalculate if hovering new tile or path was invalidated
    if (!hoverPathValid || mouse_axial.q != hoverTileQ || mouse_axial.r != hoverTileR) {
        hoverTileQ = mouse_axial.q;
        hoverTileR = mouse_axial.r;
        hoverPath = scr_hex_a_star_path(my_axial.q, my_axial.r, hoverTileQ, hoverTileR);
        hoverPathValid = true;
    }

    // Convert destination to pixel
    var mouse_pixel = scr_axial_to_pixel(hoverTileQ, hoverTileR);
    var tile_x = mouse_pixel.px + global.offsetX;
    var tile_y = mouse_pixel.py + global.offsetY;

    if (array_length(hoverPath) == 0) {
        // Unreachable — draw red ring and dot only
        draw_set_color(c_red);
        var outer_radius = global.hex_size * 0.7;
        var inner_radius = outer_radius - 2;
        for (var r = inner_radius; r <= outer_radius; r += 0.25) {
            draw_circle(tile_x, tile_y, r, true);
        }
        draw_circle(tile_x, tile_y, 3, false);
        exit;
    }

    // === Build pixel path ===
    var pts = [];
    array_push(pts, [x, y]);
    for (var i = 0; i < array_length(hoverPath); i++) {
        var tile = global.hex_grid[hoverPath[i]];
        var px = scr_axial_to_pixel(tile.q, tile.r);
        array_push(pts, [px.px + global.offsetX, px.py + global.offsetY]);
    }

    // === Animated dotted path ===
    var seg_spacing = 12;
    var dot_radius = 2;
    var offset = (current_time div 50) mod seg_spacing;
    draw_set_color(c_white);

    for (var i = 0; i < array_length(pts) - 1; i++) {
        var a = pts[i];
        var b = pts[i + 1];
        var seg_dist = point_distance(a[0], a[1], b[0], b[1]);
        var steps = ceil(seg_dist / seg_spacing);

        for (var j = 0; j <= steps; j++) {
            var t = (j * seg_spacing + offset) / seg_dist;
            if (t > 1) break;
            var px = lerp(a[0], b[0], t);
            var py = lerp(a[1], b[1], t);
            draw_circle(px, py, dot_radius, false);
        }
    }

    // === Circle at final tile
    var endTile = pts[array_length(pts) - 1];
    var outer_radius = global.hex_size * 0.7;
    var inner_radius = outer_radius - 2;
    for (var r = inner_radius; r <= outer_radius; r += 0.25) {
        draw_circle(endTile[0], endTile[1], r, true);
    }

    draw_circle(endTile[0], endTile[1], 3, false);
}
