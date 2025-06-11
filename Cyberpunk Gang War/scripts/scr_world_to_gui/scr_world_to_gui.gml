/// @function scr_world_to_gui(wx, wy)
/// @desc Converts world coordinates to GUI (screen) coordinates
/// @returns {struct} with .x and .y

function scr_world_to_gui(wx, wy) {
    var cam = view_camera[0];

    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var scale_x = gui_w / view_w;
    var scale_y = gui_h / view_h;

    return {
        x: (wx - view_x) * scale_x,
        y: (wy - view_y) * scale_y
    };
}
