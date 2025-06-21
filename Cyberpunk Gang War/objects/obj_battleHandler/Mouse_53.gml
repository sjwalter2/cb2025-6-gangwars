/// Mouse Left Pressed
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (point_in_rectangle(mx, my, 540, 950, 740, 1050)) {
    scr_resolve_battle(battle_data);
    global.activeBattle = undefined;
    instance_destroy();

    if (array_length(global.pendingBattles) > 0) {
        instance_create_layer(320, 240, "UI", obj_battleChoiceWindow);
    } else {
        with (obj_gameHandler) {
            nextSpeed = global.currentSpeedBeforeBattle;
        }
    }
}
