/// Mouse Left Pressed
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (point_in_rectangle(mx, my, x + 20, y + 100, x + 80, y + 130)) {
    instance_create_layer(0, 0, "UI", obj_battleHandler);
    instance_destroy();
}

if (point_in_rectangle(mx, my, x + 110, y + 100, x + 170, y + 130)) {
    scr_resolve_battle(global.activeBattle);
    global.activeBattle = undefined;
    instance_destroy();

    if (array_length(global.pendingBattles) == 0) {
        with (obj_gameHandler) {
            nextSpeed = global.currentSpeedBeforeBattle;
        }
    } else {
        instance_create_layer(320, 240, "Battle", obj_battleChoiceWindow);
    }
}
