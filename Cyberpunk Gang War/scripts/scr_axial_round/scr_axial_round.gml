/// @function scr_axial_round(q, r)
/// @description Rounds fractional axial coordinates to nearest hex grid
/// @param q {real} fractional axial q
/// @param r {real} fractional axial r
/// @returns {struct} A struct with .q and .r (rounded)

function scr_axial_round(q, r) {
    var cube_x = q;
    var cube_z = r;
    var cube_y = -cube_x - cube_z;

    var rx = round(cube_x);
    var ry = round(cube_y);
    var rz = round(cube_z);

    var dx = abs(rx - cube_x);
    var dy = abs(ry - cube_y);
    var dz = abs(rz - cube_z);

    if (dx > dy && dx > dz) {
        rx = -ry - rz;
    } else if (dy > dz) {
        ry = -rx - rz;
    } else {
        rz = -rx - ry;
    }

    return {q: rx, r: rz};
}
