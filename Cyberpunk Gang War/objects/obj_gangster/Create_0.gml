/// @description Gangster

owner = noone   //Gang ownership
boss = noone //Boss (optional); set to noone if gangster is a toplevel gang member

//Stats
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))

charisma = 0
might = 0
honor = 0
startGame = 1
alarm[0] = 10
alarm[1] = 1
color = c_white
autonomous = true; // Set to false for player-controlled gangsters
target_tile_index = -1;
current_tile = { q: 0, r: 0 }; // Must be updated in Step or by spawn logic

path = [];              // Will hold list of tile indices
path_progress = 0;      // Which tile in the path we're headed to
move_timer = 0;         // Countdown to move completion
state = "idle";         // ["idle", "moving", "capturing", "resupplying"]
start_tile_index = -1;  // Where we return after capturing

var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
current_tile.q = axial.q;
current_tile.r = axial.r;


//Display stuff
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))
sprite_head_index = irandom(sprite_get_number(spr_gangsterHead)-1)
image_blend = make_color_rgb(irandom(255),irandom(255),irandom(255));

displayStatsFull = false

money = 0
taxRate = 0.1

assignedPawns = irandom(4)

gangsterWidth = 0
gangsterHeight = 0

is_moving = false;
move_queued = false;
move_target = undefined;
move_ticks_remaining = 0;
flash_timer = 0;
flash_type = ""; // "move" or "arrive"
first_tick_bonus = 0;
FLICKER_TOGGLE_MIN = 100;  // ms or tick equivalent
FLICKER_TOGGLE_MAX = 300;
//Pathfinding
hoverPathValid = false;
hoverTileQ = 0;
hoverTileR = 0;
hoverPath = [];

capture_ticks_remaining = 0;
capture_tile_index = -1;


// Path following support
move_path = [];         // Array of remaining tile indices to follow
has_followup_move = false;  // Whether to continue pathing after reaching this tile


with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function draw_polygon(cx, cy, radius, sides) {
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(cx, cy);
    for (var i = 0; i <= sides; i++) {
        var angle = degtorad(i * 360 / sides);
        var px = cx + cos(angle) * radius;
        var py = cy + sin(angle) * radius;
        draw_vertex(px, py);
    }
    draw_primitive_end();
}

with (instance_create_depth(x+sprite_width+18,y-22,0,obj_buttonInfo))
{
	relativeX = sprite_width+8
	relativeY = -22
	parent=other
}


/// @function array_shift(arr)
/// @description Removes and returns the first element of the array
function array_shift(arr) {
    var result = arr[0];
    for (var i = 1; i < array_length(arr); i++) {
        arr[i - 1] = arr[i];
    }
    array_resize(arr, array_length(arr) - 1);
    return result;
}


function tick() {
		if (state == "capturing") {
	    capture_ticks_remaining--;

	    // Flash effect (optional)
	    flash_timer = current_time + 200;
	    flash_type = "capture";

	    if (capture_ticks_remaining <= 0) {
	        scr_claim_tile(capture_tile_index, owner);

	        // Reset capture state

	        capture_tile_index = -1;
	        capture_ticks_remaining = 0;
	        flash_timer = current_time + 300;
	        flash_type = "complete";

	        state = "idle";
	    }

	    return;
	}

    if (move_queued) {
        move_queued = false;
        is_moving = true;
        return; // Start next tick
    }

    if (is_moving) {
        // Flash and position updates
        flash_timer = current_time + 150;
        flash_type = "move";

        var t = move_ticks_elapsed / move_total_ticks;
        var start = move_target.start_pos;
        var target = move_target.target_pos;

        x = lerp(start.x, target.x, t);
        y = lerp(start.y, target.y, t);

        move_ticks_elapsed++;
        first_tick_bonus = 0;

        if (move_ticks_elapsed >= move_total_ticks) {
            // Snap to final position
            x = target.x;
            y = target.y;

            // Release claimed tile
            var idx = ds_list_find_index(global.claimed_tile_indices, move_target.tile_index);
            if (idx != -1) ds_list_delete(global.claimed_tile_indices, idx);

            is_moving = false;
            move_target = undefined;
            move_ticks_elapsed = 0;
            move_total_ticks = 0;

            flash_timer = current_time + 300;
            flash_type = "arrive";

            // === Check for next step ===
			if (has_followup_move && array_length(move_path) > 0) {
			    var next_tile_index = array_shift(move_path);
			    if (array_length(move_path) == 0) has_followup_move = false;
			    scr_gangster_start_movement(self, next_tile_index, 0);
			} else {
			    // No more moves — check for capture
			    var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
				var key = string(axial.q) + "," + string(axial.r);

				if (!ds_map_exists(global.hex_lookup, key)) exit;
				var final_tile_index = global.hex_lookup[? key];
				var tile = global.hex_grid[final_tile_index];

				if (tile.owner != owner.name) {
				    state = "capturing";

				    var move_cost = global.cost_unclaimed;
				    if (!is_undefined(tile.owner)) move_cost = global.cost_enemy;

				    capture_ticks_remaining = move_cost * 2;
				    capture_tile_index = final_tile_index;

				    // 🟡 Trigger flickering
				    var tile_ref = global.hex_grid[capture_tile_index];
				    tile_ref.flicker_enabled = true;
				    tile_ref.flicker_timer = current_time + irandom_range(FLICKER_TOGGLE_MIN, FLICKER_TOGGLE_MAX);
				    tile_ref.flicker_next = current_time + 1000; // minimum delay between full cycles
				    tile_ref.flicker_on = false;
				    tile_ref.pending_color = scr_get_gang_color(owner.name);
				    tile_ref.pending_owner = owner.name;
				    global.hex_grid[capture_tile_index] = tile_ref;
				}

				else {
			        state = "idle";
			    }
			}

        }
    }
}
