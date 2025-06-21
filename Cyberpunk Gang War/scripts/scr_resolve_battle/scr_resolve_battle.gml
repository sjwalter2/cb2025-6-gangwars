/// @function scr_resolve_battle(battle_data)
/// Resolves a battle either automatically or after manual button press

function scr_resolve_battle(battle_data) {
    var attacker = battle_data.attacker;
    var defender = battle_data.defender;
    var tile_index = battle_data.tile_index;

    var fail_chance = defender.captures_since_resupply < global.resupply_tile_limit
        ? global.intervene_fail_chance_with_capture
        : global.intervene_fail_chance_without_capture;

    var capture_success = random(1) >= fail_chance;

    var popup = instance_create_layer(attacker.x, attacker.y - 24, "UI", obj_popup_text);
    popup.ttl = 150;

    if (capture_success) {
        popup.text = "CAPTURED";
        popup.color = c_red;
		with(attacker)
			scr_claim_tile(tile_index, attacker.owner);
    } else {
        popup.text = "DEFENDED";
        popup.color = c_lime;
    }

    attacker.captures_since_resupply = global.resupply_tile_limit;
    defender.captures_since_resupply =  global.resupply_tile_limit;
}
