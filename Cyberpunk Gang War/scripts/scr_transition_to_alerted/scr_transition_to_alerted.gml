/// @function scr_transition_to_alerted(gangster)
/// @desc Resumes alerted movement after interruption by transferring alert path and targeting info.

function scr_transition_to_alerted(gangster) {
    gangster.path = gangster.alert_path;
    gangster.move_path = gangster.alert_path;
    gangster.target_tile_index = gangster.alert_target_tile_index;
    gangster.path_progress = 0;
    gangster.move_elapsed = 0;
    gangster.is_intervening_path = true;
    gangster.state = "moving";
	var next_tile_index = array_shift(gangster.alert_path)
    scr_gangster_start_movement(gangster, next_tile_index , false);
}
