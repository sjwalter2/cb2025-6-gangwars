/// @function scr_axial_key(q, r)
/// @desc Returns a unique integer key for axial coords (up to ~10,000 width)
function scr_axial_key(q, r) {
    return (q + 5000) * 10000 + (r + 5000); // supports -5000 to +4999

}
