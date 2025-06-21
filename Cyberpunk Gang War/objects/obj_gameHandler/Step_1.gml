// Clear existing tile maps
ds_map_clear(global.gangster_tile_map);
ds_map_clear(global.tile_reservations);

// Keep a list of all current move target tile indices
var valid_claimed = ds_list_create();

// Rebuild gangster_tile_map and collect current move targets
with (obj_gangster) {
    // Add gangster position to tile map
    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
    var key = scr_axial_key(axial.q, axial.r);
    global.gangster_tile_map[? key] = id;

    // Add move target tile index to valid_claimed list
    if (is_struct(move_target) && variable_struct_exists(move_target, "tile_index")) {
        ds_list_add(valid_claimed, move_target.tile_index);
    }
}

// Remove invalid claimed tiles
for (var i = ds_list_size(global.claimed_tile_indices) - 1; i >= 0; i--) {
    var claimed_idx = global.claimed_tile_indices[| i];
    if (ds_list_find_index(valid_claimed, claimed_idx) == -1) {
        ds_list_delete(global.claimed_tile_indices, i);
    }
}

ds_list_destroy(valid_claimed);
