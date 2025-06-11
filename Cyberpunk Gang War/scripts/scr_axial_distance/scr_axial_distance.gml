/// @function scr_axial_distance(q1, r1, q2, r2)
/// @desc Returns hex distance between two axial coordinates
/// @param {q1, r1, q2, r2}

function scr_axial_distance(q1, r1, q2, r2) {
    var dq = abs(q2 - q1);
    var dr = abs(r2 - r1);
    var ds = abs((-q2 - r2) - (-q1 - r1)); // equivalent to abs(s2 - s1)
    return max(dq, dr, ds);
}