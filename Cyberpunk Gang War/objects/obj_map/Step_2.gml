// === SMOOTH ZOOM ===
cam_zoom_current = lerp(cam_zoom_current, cam_zoom_target, 0.2);
var view_w = cam_zoom_current;
var view_h = view_w * (9 / 16);

// === APPLY INERTIA (if not actively dragging) ===
if (!is_dragging) {
    cam_vel_x *= drag_inertia;
    cam_vel_y *= drag_inertia;

    cam_target_x += cam_vel_x;
    cam_target_y += cam_vel_y;
}

// === Clamp Target Position ===
var half_w = view_w / 2;
var half_h = view_h / 2;

cam_target_x = clamp(cam_target_x, map_bound_left + half_w, map_bound_right - half_w);
cam_target_y = clamp(cam_target_y, map_bound_top + half_h, map_bound_bottom - half_h);

// === Smooth Camera Position ===
cam_pos_x = lerp(cam_pos_x, cam_target_x, 0.25);
cam_pos_y = lerp(cam_pos_y, cam_target_y, 0.25);

// === Update Camera ===
var cam = view_camera[0];
camera_set_view_size(cam, view_w, view_h);
camera_set_view_pos(cam, cam_pos_x - half_w, cam_pos_y - half_h);
