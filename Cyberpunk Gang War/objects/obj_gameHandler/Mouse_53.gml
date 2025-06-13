if (mouse_check_button_pressed(mb_left)) {
    scr_try_gangster_move_or_select();

    // Later you'll be able to say:
    // if (!global.selection_cooldown) scr_try_select_other_things();
}
