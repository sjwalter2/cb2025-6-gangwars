/// Step Event
if (keyboard_check_pressed(vk_right)) {
    bg_effect_fade_dir = -1;
}

if (current_time - bg_effect_timer > bg_effect_duration || bg_effect_fade_dir == -1) {
    bg_effect_fade_dir = -1;
    bg_effect_fade -= 0.01;
    if (bg_effect_fade <= 0) {
        bg_effect_fade = 0;
        bg_effect_fade_dir = 1;

        // Mark effect as played
        bg_effect_played[bg_effect_index] = true;

        // All played? Reset
        var all_played = true;
        for (var i = 0; i < array_length(bg_effect_played); i++) {
            if (!bg_effect_played[i]) {
                all_played = false;
                break;
            }
        }
        if (all_played) {
            for (var i = 0; i < array_length(bg_effect_played); i++) {
                bg_effect_played[i] = false;
            }
        }

        // Choose new index
        var next_indices = [];
        for (var i = 0; i < array_length(bg_effect_played); i++) {
            if (!bg_effect_played[i]) array_push(next_indices, i);
        }
        if (array_length(next_indices) > 0) {
            bg_effect_index = next_indices[irandom(array_length(next_indices) - 1)];
        }

        // Pick new color
        bg_effect_color = make_color_rgb(irandom(255), irandom(255), irandom(255));

        bg_effect_timer = current_time;
    }
} else if (bg_effect_fade_dir == 1 && bg_effect_fade < 1) {
    bg_effect_fade += 0.01;
    if (bg_effect_fade > 1) bg_effect_fade = 1;
}