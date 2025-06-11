/// @function scr_gui_to_world(mx, my)
/// @desc Converts GUI coordinates to world (room) coordinates
/// @param mx GUI x
/// @param my GUI y
/// @returns {struct} with .x and .y

function scr_gui_to_world(mx, my) {
    var cam = view_camera[0];

    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var scale_x = view_w / gui_w;
    var scale_y = view_h / gui_h;

    return {
        x: view_x + mx * scale_x,
        y: view_y + my * scale_y
    };
}
