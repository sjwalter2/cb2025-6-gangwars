if (mouse_check_button_pressed(mb_left)) {
    if (ds_list_size(global.selected) > 0) {
        var gangster = global.selected[| 0];

        // Convert mouse to axial coordinates
        var axial_target = scr_pixel_to_axial(mouse_x - global.offsetX, mouse_y - global.offsetY);
        var q2 = axial_target.q;
        var r2 = axial_target.r;

        // Check if the target tile is occupied by another gangster
        var target_occupied = false;
        var clicked_gangster = noone;

        with (obj_gangster) {
            var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
            if (my_axial.q == q2 && my_axial.r == r2) {
                target_occupied = true;
                clicked_gangster = id;
            }
        }

        if (target_occupied) {
            ds_list_clear(global.selected);
            ds_list_add(global.selected, clicked_gangster);
            exit;
        }

        // Get current tile of the selected gangster
        var axial_current = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
        var q1 = axial_current.q;
        var r1 = axial_current.r;

        var dq = abs(q2 - q1);
        var dr = abs(r2 - r1);
        var ds = abs((-q2 - r2) - (-q1 - r1));
        var dist = max(dq, dr, ds);

        if (dist == 1) {
            for (var i = 0; i < array_length(global.hex_grid); i++) {
                var tile = global.hex_grid[i];
                if (tile.q == q2 && tile.r == r2) {
                    scr_gangster_start_movement(gangster, i);
                    global.selection_cooldown = true;
                    break;
                }
            }
        }
    }
}
