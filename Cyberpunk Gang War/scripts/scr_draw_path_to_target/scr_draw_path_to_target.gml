/// @function scr_draw_path_to_target()
/// @description Draws an animated dotted line and thick border circle from selected gangster to hovered adjacent tile

function scr_draw_path_to_target() {
    if (ds_list_find_index(global.selected, self) == -1) exit;

    var mouse_axial = scr_pixel_to_axial(mouse_x - global.offsetX, mouse_y - global.offsetY);
    var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);

    var dq = abs(mouse_axial.q - my_axial.q);
    var dr = abs(mouse_axial.r - my_axial.r);
    var ds = abs((-mouse_axial.q - mouse_axial.r) - (-my_axial.q - my_axial.r));
    var dist = max(dq, dr, ds);

    if (dist != 1) exit;

    // Convert axial to pixel positions
    var mouse_pixel = scr_axial_to_pixel(mouse_axial.q, mouse_axial.r);
    var tile_x = mouse_pixel.px + global.offsetX;
    var tile_y = mouse_pixel.py + global.offsetY;

    // === Animated dotted line ===
    var seg_spacing = 12;
    var dot_radius = 2;
    var total_dist = point_distance(x, y, tile_x, tile_y);
    var offset = (current_time div 50) mod seg_spacing;
    var steps = ceil(total_dist / seg_spacing); // ensure full coverage

    draw_set_color(c_white);
    for (var i = 0; i <= steps; i++) {
        var t = (i * seg_spacing + offset) / total_dist;
        t = clamp(t, 0, 1); // ensure we never overshoot
        var px = lerp(x, tile_x, t);
        var py = lerp(y, tile_y, t);
        draw_circle(px, py, dot_radius, false);
    }

    // === Thick circle border ===
    var outer_radius = global.hex_size * 0.7;
    var inner_radius = outer_radius - 2;
    for (var r = inner_radius; r <= outer_radius; r += 0.25) {
        draw_circle(tile_x, tile_y, r, true);
    }

    // === Center dot ===
    draw_circle(tile_x, tile_y, 3, false);
}
