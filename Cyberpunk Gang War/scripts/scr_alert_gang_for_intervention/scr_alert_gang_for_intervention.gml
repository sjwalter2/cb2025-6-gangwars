/// @function scr_alert_gang_for_intervention(tile_index, capturing_gangster_id)
/// @desc Alerts all gangsters of the defending gang to potentially intervene.
/// @param tile_index - index of the tile being captured
/// @param capturing_gangster_id - id of the gangster initiating the capture

function scr_alert_gang_for_intervention(tile_index, capturing_gangster_id) {
    var tile = global.hex_grid[tile_index];
    var defending_gang = tile.owner;

    // Notify each gangster of the defending gang
    with (obj_gangster) {
        if (remaining_stronghold && !alert_responding && owner.name == defending_gang && id != capturing_gangster_id) {
            alert_tile_index = tile_index;
			//if(state = "moving")
			//	has_followup_move = false;
            alert_active = true;
        }
    }
}
