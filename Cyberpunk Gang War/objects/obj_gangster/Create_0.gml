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
state = "idle";         // state = ["idle", "thinking", "deciding", "moving", "capturing", "resupplying", "waiting"]
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

assignedPawns = 0

gangsterWidth = 0
gangsterHeight = 0

is_moving = false;
move_queued = false;
move_target = undefined;
move_ticks_remaining = 0;
stuck_waiting = 0;
stuck_waiting_trigger = 0;

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

alert_path = [];
alert_target_tile_index = -1;
is_intervening_path = false;
alerted_by = noone;
alert_after_move = false;

move_ticks_elapsed = 0;
move_total_ticks = 0;
capture_ticks_remaining = 0;
capture_tile_index = -1;

captures_since_resupply = 0;
resupply_ticks_remaining = 0;
reserved_stronghold_key = undefined;



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
        scr_tick_gangster_capturing(self);
        return;
    }

    if (state == "alerted") {
        scr_tick_gangster_alerted(self);
        return;
    }
	if (state == "intervening") {
	    scr_tick_gangster_intervening(self);
	    return;
	}
    if (state == "resupplying") {
        scr_tick_gangster_resupplying(self);
        return;
    }

    if (state == "waiting") {
		if(stuck_waiting_trigger)
			stuck_waiting++;
		else
			stuck_waiting = 0;
        move_queued = false;
        is_moving = true;
        state = "moving";
		stuck_waiting_trigger = 1;
        return;
    } 

    if (state == "moving") {
		if(stuck_waiting > 3)
			var k = 1;
		if ( move_total_ticks <= 0) 
		{
	        is_moving = false;
	        move_target = undefined;
	        state = "idle";
			move_target = undefined;
		    move_ticks_elapsed = 0;
		    move_total_ticks = 0;
	        return;
	    }

        scr_tick_gangster_moving(self);
		stuck_waiting_trigger = 0;
        return;
    }
}
