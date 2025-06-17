/// @function scr_select_object(width, height)
/// @desc Selects the object if the mouse is inside a centered square hitbox
/// @param width {real} - Hitbox width
/// @param height {real} - Hitbox height

function scr_select_object(_w, _h) {
	if (global.selection_cooldown) exit;
    var left   = x - _w * 0.5;
    var right  = x + _w * 0.5;
    var top    = y - _h * 0.5;
    var bottom = y + _h * 0.5;

    var in_bounds = (mouse_x > left && mouse_x < right && mouse_y > top && mouse_y < bottom);
    var index = ds_list_find_index(global.selected, self);

    if (in_bounds) {
        if (index == -1) {
            ds_list_clear(global.selected); // ensure only one selected at a time
            ds_list_add(global.selected, self);
        }
        // already selected: do nothing
    } else {
        if (index != -1) {
            ds_list_delete(global.selected, index);
        }
    }
}
