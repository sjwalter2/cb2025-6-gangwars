// === ZOOM CONTROL (Mouse Wheel Up/Down) ===
if (mouse_wheel_down()) {
    global.cam_zoom_index = max(0, global.cam_zoom_index - 1);
    global.cam_zoom_target = global.cam_zoom_levels[global.cam_zoom_index];
}
if (mouse_wheel_up()) {
    global.cam_zoom_index = min(array_length(global.cam_zoom_levels) - 1, global.cam_zoom_index + 1);
    global.cam_zoom_target = global.cam_zoom_levels[global.cam_zoom_index];
}

// === SMOOTH ZOOM ===
global.cam_zoom_current = lerp(global.cam_zoom_current, global.cam_zoom_target, 0.2);
var view_w = global.cam_zoom_current;
var view_h = view_w * (9 / 16);

// === MOUSE DRAG PAN ===
if (mouse_check_button_pressed(mb_left)) {
    global.is_dragging = true;
    global.drag_start_x = device_mouse_x_to_gui(0);
    global.drag_start_y = device_mouse_y_to_gui(0);
    global.drag_cam_start_x = global.cam_target_x;
    global.drag_cam_start_y = global.cam_target_y;
}
if (mouse_check_button_released(mb_left)) {
    global.is_dragging = false;
}

if (global.is_dragging) {
    var dx = device_mouse_x_to_gui(0) - global.drag_start_x;
    var dy = device_mouse_y_to_gui(0) - global.drag_start_y;

    global.cam_target_x = global.drag_cam_start_x - dx;
    global.cam_target_y = global.drag_cam_start_y - dy;

    // Record velocity for inertia
    global.cam_vel_x = -dx;
    global.cam_vel_y = -dy;
} else {
    // Apply inertia
    global.cam_vel_x *= global.drag_inertia;
    global.cam_vel_y *= global.drag_inertia;
    global.cam_target_x += global.cam_vel_x;
    global.cam_target_y += global.cam_vel_y;
}

// === Clamp to map bounds ===
var half_w = view_w / 2;
var half_h = view_h / 2;

global.cam_target_x = clamp(global.cam_target_x, 0 + half_w, room_width - half_w);
global.cam_target_y = clamp(global.cam_target_y, 0 + half_h, room_height - half_h);

// === Smooth Camera Position ===
global.cam_pos_x = lerp(global.cam_pos_x, global.cam_target_x, 0.25);
global.cam_pos_y = lerp(global.cam_pos_y, global.cam_target_y, 0.25);

// === Update View ===
var cam = view_camera[0];
camera_set_view_size(cam, view_w, view_h);
camera_set_view_pos(cam, global.cam_pos_x - half_w, global.cam_pos_y - half_h);
