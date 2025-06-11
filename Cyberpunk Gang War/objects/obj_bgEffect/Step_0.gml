if (keyboard_check_pressed(vk_right)) {
    bg_effect_fade_dir = -1;
}

if (current_time - bg_effect_timer > bg_effect_duration || bg_effect_fade_dir == -1) {
    bg_effect_fade_dir = -1;
    bg_effect_fade -= 0.01;
    if (bg_effect_fade <= 0) {
        bg_effect_fade = 0;
        bg_effect_fade_dir = 1;

        // Track last effect index
        var bg_effect_last_index = bg_effect_index;

        // Mark as played
        bg_effect_played[bg_effect_index] = true;

        // Check if all have played
        var all_played = true;
        for (var i = 0; i < array_length(bg_effect_played); i++) {
            if (!bg_effect_played[i]) {
                all_played = false;
                break;
            }
        }

        // Reset played flags if needed
        if (all_played) {
            for (var i = 0; i < array_length(bg_effect_played); i++) {
                bg_effect_played[i] = false;
            }
            // Mark the current one as played again so it won't repeat
            bg_effect_played[bg_effect_last_index] = true;
        }

        // Build candidate list (excluding last one if possible)
        var next_indices = [];
        for (var i = 0; i < array_length(bg_effect_played); i++) {
            if (!bg_effect_played[i] && i != bg_effect_last_index) {
                array_push(next_indices, i);
            }
        }

        // If all others are played and only last is left, allow it
        if (array_length(next_indices) == 0) {
            for (var i = 0; i < array_length(bg_effect_played); i++) {
                if (!bg_effect_played[i]) {
                    array_push(next_indices, i);
                }
            }
        }

        // Pick new index and randomize parameters
        if (array_length(next_indices) > 0) {
            bg_effect_index = next_indices[irandom(array_length(next_indices) - 1)];
            randomize_effect(bg_effect_index);
        }

        // Pick new color
        bg_effect_color = make_color_hsv(irandom(255), 255, 255);

        bg_effect_timer = current_time;
    }
} else if (bg_effect_fade_dir == 1 && bg_effect_fade < 1) {
    bg_effect_fade += 0.01;
    if (bg_effect_fade > 1) bg_effect_fade = 1;
}
