// === Suppress default GUI from obj_map ===
// === Mouse hover detection with zoom compensation ===
var cam = view_camera[0];
var view_x = camera_get_view_x(cam);
var view_y = camera_get_view_y(cam);
var view_w = camera_get_view_width(cam);
var view_h = camera_get_view_height(cam);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var scale_x = view_w / gui_w;
var scale_y = view_h / gui_h;

// Convert mouse position to world space
var mouse_world_x = view_x + device_mouse_x_to_gui(0) * scale_x;
var mouse_world_y = view_y + device_mouse_y_to_gui(0) * scale_y;

