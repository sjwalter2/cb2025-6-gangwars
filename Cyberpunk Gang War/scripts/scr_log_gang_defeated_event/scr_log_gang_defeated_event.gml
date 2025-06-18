function scr_log_gang_defeated_event(gang_name, color) {
    var msg = {
        type: "defeat",
        time_created: current_time,
        duration: 20000,
        prev_owner: gang_name,
        prev_color: color
    };

    array_insert(obj_eventLogger.defeat_messages, 0, msg); // insert at front

    if (array_length(obj_eventLogger.defeat_messages) > obj_eventLogger.max_visible) {
        array_resize(obj_eventLogger.defeat_messages, obj_eventLogger.max_visible);
    }
}
