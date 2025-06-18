// Remove expired normal messages
for (var i = array_length(messages) - 1; i >= 0; i--) {
    var m = messages[i];
    if ((!variable_struct_exists(m, "type") || m.type != "defeat") && current_time - m.time_created >= m.duration) {
        array_delete(messages, i, 1);
    }
}

// Remove expired defeat messages
for (var i = array_length(defeat_messages) - 1; i >= 0; i--) {
    var m = defeat_messages[i];
    if (current_time - m.time_created >= m.duration) {
        array_delete(defeat_messages, i, 1);
    }
}
