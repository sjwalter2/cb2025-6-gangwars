/// @function scr_pixel_to_axial(px, py)
/// @description Converts pixel coordinates to axial hex coordinates (rounded).
/// @param px {real} Pixel X
/// @param py {real} Pixel Y
/// @returns {struct} A struct with .q and .r (axial coordinates)

function scr_pixel_to_axial(px, py) {
    var spacing = 1.1;
    var hex_size = global.hex_size;

    var q = ((sqrt(3)/3 * px) - (1/3 * py)) / (spacing * hex_size);
    var r = (2/3 * py) / (spacing * hex_size);

    return scr_axial_round(q, r);
}
