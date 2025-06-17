/// Create Event for obj_stronghold

// === GLOBAL NAME POOLS ===
if (!variable_global_exists("gangadjectives")) {
	global.gangadjectives = scr_generate_names("gangfirstnames.txt");
}

if (!variable_global_exists("strongholdnouns")) {
	global.strongholdnouns = scr_generate_names("strongholdnouns.txt");
}

if (!variable_global_exists("used_stronghold_names")) {
	global.used_stronghold_names = [];
}

// === UNIQUE NAME GENERATION ===
name = "";
repeat (100) { // Cap attempts to avoid infinite loop
	var adj = scr_get_name(global.gangadjectives);
	var noun = scr_get_name(global.strongholdnouns);
	var try_name = adj + " " + noun;

	var is_unique = true;
	for (var i = 0; i < array_length(global.used_stronghold_names); i++) {
	    if (global.used_stronghold_names[i] == try_name) {
	        is_unique = false;
	        break;
	    }
	}

	if (is_unique) {
	    name = try_name;
	    array_push(global.used_stronghold_names, name);
	    break;
	}
}

// === INITIAL STATE ===
owner = noone;          // Will be set when gangs are assigned
tile_index = -1;        // Tile index on the hex grid
resupply_timer = 0;     // Placeholder for future logic
q = -1
r = -1
assignedPawns = 0