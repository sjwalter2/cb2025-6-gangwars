/// @function scr_try_gangster_move_or_select()
/// @description Handles left-clicks for selecting or moving a gangster.

function scr_try_gangster_move_or_select(q2, r2) {
    if (ds_list_size(global.selected) == 0) return;

    var gangster = global.selected[| 0];

    // Check if tile is occupied
    var target_occupied = false;
    var clicked_gangster = noone;



    if (target_occupied) {
        ds_list_clear(global.selected);
        ds_list_add(global.selected, clicked_gangster);
        return;
    }

    // Compute full A* path from current to clicked tile
    var axial_current = scr_pixel_to_axial(gangster.x - global.offsetX, gangster.y - global.offsetY);
    var path = scr_hex_a_star_path(axial_current.q, axial_current.r, q2, r2, gangster.owner.name);

    if (array_length(path) == 0) return; // Unreachable

    // Start first movement step
    gangster.move_path = path;
	gangster.has_followup_move = true;

	var first_step = array_shift(gangster.move_path);
	if (array_length(gangster.move_path) == 0) gangster.has_followup_move = false;

	scr_gangster_start_movement(gangster, first_step);


    global.selection_cooldown = true;
}
