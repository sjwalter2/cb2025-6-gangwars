function scr_get_gang_color(gang_name) {
    for (var i = 0; i < array_length(global.gang_territories); i++) {
        var g = global.gang_territories[i];
        if (g.name == gang_name) return g.color;
    }
    return c_gray;
};
