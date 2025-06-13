function scr_log_capture_event(gangster_name, new_owner, new_color, q, r, prev_owner, prev_color) {
    var msg = {
        time_created: current_time,
        duration: 4000,
        q: q,
        r: r,
        gangster: gangster_name,
        new_owner: new_owner,
        new_color: new_color,
        prev_owner: prev_owner,
        prev_color: prev_color
    };

    array_insert(obj_eventLogger.messages, 0, msg); // add to front

    // Trim if exceeding limit
    if (array_length(obj_eventLogger.messages) > obj_eventLogger.max_visible) {
        array_resize(obj_eventLogger.messages, obj_eventLogger.max_visible);
    }
}
