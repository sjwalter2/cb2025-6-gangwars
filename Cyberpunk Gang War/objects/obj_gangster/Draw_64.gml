/// @description Draws hover tooltip in GUI space for this gangster

// === Mouse hover detection with zoom compensation ===
if(draw_gui)
{
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


// === Gather gang data ===
var gang_name = "Unknown Gang";
var gang_color = c_gray;

if (variable_instance_exists(id, "owner") && instance_exists(owner)) {
    if (variable_instance_exists(owner, "name")) {
        gang_name = owner.name;
    }
    if (variable_instance_exists(owner, "color")) {
        gang_color = owner.color;
    }
}

// === Convert gangster position to GUI space ===
var pos_gui = scr_world_to_gui(x, y);
var gui_x = pos_gui.x;
var gui_y = pos_gui.y;

// === Tooltip layout ===
var tooltip_text_1 = name;
var tooltip_text_2 = gang_name;

var padding = 8;
var spacing = 6;

var text_width = max(string_width(tooltip_text_1), string_width(tooltip_text_2));
var box_width = text_width + padding * 2;
var box_height = string_height(tooltip_text_1) + string_height(tooltip_text_2) + spacing + padding * 2;

var triangle_height = 10;
var triangle_width = 14;

// === Default position: above gangster ===
var box_x = gui_x - box_width / 2;
var box_y = gui_y - triangle_height - box_height - 4;
var triangle_dir = "down";

// === Reposition if offscreen ===
if (box_y < 0) {
    var try_y = gui_y + triangle_height + 4;
    if (try_y + box_height < gui_h) {
        box_y = try_y;
        triangle_dir = "up";
    } else {
        var try_right = gui_x + triangle_height + 4;
        var try_left = gui_x - box_width - triangle_height - 4;

        if (try_right + box_width < gui_w) {
            box_x = try_right;
            box_y = gui_y - box_height / 2;
            triangle_dir = "left";
        } else if (try_left > 0) {
            box_x = try_left;
            box_y = gui_y - box_height / 2;
            triangle_dir = "right";
        }
    }
}

// === Draw the box ===
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, false);

// === Draw triangle pointer ===
draw_set_color(c_black);
draw_primitive_begin(pr_trianglelist);

switch (triangle_dir) {
    case "down":
        draw_vertex(gui_x, gui_y);
        draw_vertex(gui_x - triangle_width / 2, gui_y - triangle_height);
        draw_vertex(gui_x + triangle_width / 2, gui_y - triangle_height);
        break;
    case "up":
        draw_vertex(gui_x, gui_y);
        draw_vertex(gui_x - triangle_width / 2, gui_y + triangle_height);
        draw_vertex(gui_x + triangle_width / 2, gui_y + triangle_height);
        break;
    case "left":
        draw_vertex(gui_x, gui_y);
        draw_vertex(gui_x + triangle_height, gui_y - triangle_width / 2);
        draw_vertex(gui_x + triangle_height, gui_y + triangle_width / 2);
        break;
    case "right":
        draw_vertex(gui_x, gui_y);
        draw_vertex(gui_x - triangle_height, gui_y - triangle_width / 2);
        draw_vertex(gui_x - triangle_height, gui_y + triangle_width / 2);
        break;
}

draw_primitive_end();
draw_set_alpha(1);

// === Draw text ===
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(scr_get_gang_color(owner.name));
draw_text(box_x + box_width / 2, box_y + padding, tooltip_text_1);

draw_set_color(scr_get_gang_color(owner.name));
draw_text(box_x + box_width / 2, box_y + padding + string_height(tooltip_text_1) + spacing, tooltip_text_2);

}