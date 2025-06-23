function scr_check_remaining_stronghold(gang_name) {
    	var have_stronghold = false;
    // === Check if any owned stronghold exists ===
    for (var i = 0; i < array_length(global.hex_grid); i++) {
        var tile = global.hex_grid[i];
        if (tile.type == "stronghold" && tile.owner == gang_name) {
            have_stronghold = true;
			break;
        }
    }
	return have_stronghold;
}