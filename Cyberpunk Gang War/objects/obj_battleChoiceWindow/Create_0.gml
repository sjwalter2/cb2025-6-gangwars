/// Create Event
popup_width = 200;
popup_height = 200;

battle_data = array_pop(global.pendingBattles);
global.activeBattle = battle_data;
global.inputLocked = true;

x = (display_get_gui_width() - popup_width) / 2;
y = (display_get_gui_height() - popup_height) / 2;
