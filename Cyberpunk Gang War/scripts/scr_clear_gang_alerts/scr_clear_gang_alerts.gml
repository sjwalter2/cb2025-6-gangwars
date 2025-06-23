/// @function scr_clear_gang_alerts(gang_name)
/// @desc Clears all alerts for the given gang.

function scr_clear_gang_alerts(gang_name, gangster, alertTile) {
    with (obj_gangster) {
        if (id!= gangster && owner.name == gang_name && !alert_responding && alert_tile_index == alertTile) {
            alert_active = false;
            alert_tile_index = -1;
        }
    }
}
