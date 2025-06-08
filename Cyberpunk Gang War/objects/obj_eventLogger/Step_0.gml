// Remove expired messages
for (var i = array_length(messages) - 1; i >= 0; i--) {
    var m = messages[i];
    if (current_time - m.time_created >= m.duration) {
        array_delete(messages, i, 1);
    }
}
