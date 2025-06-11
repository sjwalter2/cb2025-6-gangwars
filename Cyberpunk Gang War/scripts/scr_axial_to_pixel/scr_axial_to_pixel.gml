/// @function scr_axial_to_pixel(q, r)
/// @description Converts axial hex coordinates to pixel coordinates using global.hex_size.
/// @param q {real} Axial Q
/// @param r {real} Axial R
/// @returns {struct} A struct with .px and .py

function scr_axial_to_pixel(q, r) {
    if (is_undefined(q) || is_undefined(r)) {
        show_debug_message("scr_axial_to_pixel: invalid input q=" + string(q) + " r=" + string(r));
        return {px: 0, py: 0};
    }

    var spacing = 1.1;
    var hex_size = global.hex_size;

    var px = spacing * hex_size * sqrt(3) * (q + r * 0.5);
    var py = spacing * hex_size * 1.5 * r;

    return {px: px, py: py};
}
