/// scr_tick_gangster_resupplying(gangster)
function scr_tick_gangster_resupplying(gangster) {
    if (gangster.reserved_stronghold_key == undefined) {
        gangster.reserved_stronghold_key = scr_find_closest_friendly_stronghold(gangster.owner.name, gangster.x, gangster.y);
        if (gangster.reserved_stronghold_key == undefined) return;
    }

    var axial = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var sx = floor(gangster.reserved_stronghold_key / 10000) - 5000;
    var sy = gangster.reserved_stronghold_key mod 10000 - 5000;
    var dist = scr_axial_distance(axial.q, axial.r, sx, sy);

    var occupied = false;
    var stronghold_key = scr_axial_key(sx, sy);
    if (ds_map_exists(global.gangster_tile_map, stronghold_key)) {
        var blocker = global.gangster_tile_map[? stronghold_key];
        if (blocker != gangster.id && instance_exists(blocker) && blocker.owner.name != gangster.owner.name) {
            occupied = true;
        }
    }

    if (dist > 1 || (dist == 1 && !occupied)) {
        var path = scr_hex_a_star_path(axial.q, axial.r, sx, sy, gangster.owner.name);
        if (is_array(path) && array_length(path) > 0) {
            gangster.move_path = path;
            gangster.has_followup_move = true;
            var first_step = array_shift(gangster.move_path);
            if (array_length(gangster.move_path) == 0) gangster.has_followup_move = false;
            scr_gangster_start_movement(gangster, first_step, true);
            gangster.state = "waiting";
        }
        return;
    }

    if (dist == 1 && occupied) return;

    gangster.resupply_ticks_remaining++;
    if (gangster.resupply_ticks_remaining >= global.resupply_tick_cost) {
        gangster.captures_since_resupply = 0;
        gangster.resupply_ticks_remaining = 0;
        gangster.reserved_stronghold_key = undefined;
        gangster.state = "idle";
    }
}