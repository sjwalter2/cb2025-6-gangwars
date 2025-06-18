// scr_tick_gangster_intervening()
function scr_tick_gangster_intervening(gangster) {
    // Wait on the tile until capture resolves
    gangster.flash_timer = current_time + 150;
    gangster.flash_type = "intervene";
}
