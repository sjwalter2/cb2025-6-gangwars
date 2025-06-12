/// @description Gangster

owner = noone   //Gang ownership
boss = noone //Boss (optional); set to noone if gangster is a toplevel gang member

//Stats
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))

charisma = 0
might = 0
honor = 0

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
show_debug_message(name)

money = 0
taxRate = 0.1

gangsterWidth = 0
gangsterHeight = 0

is_moving = false;
move_queued = false;
move_target = undefined;
move_ticks_remaining = 0;
flash_timer = 0;
flash_type = ""; // "move" or "arrive"
first_tick_bonus = 0;

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

//with (instance_create_depth(x+sprite_width+18,y-22,0,obj_buttonInfo))
//{
//	relativeX = sprite_width+18
//	relativeY = -22
//	parent=other
//}

function tick() {
	if (move_queued) {
	    move_queued = false;
	    is_moving = true;
		
	    return; // skip rest of this tick so they start fresh on the next
	}

    if (is_moving) {
        show_debug_message("Tick: " + name + " (" + string(move_ticks_elapsed) + "/" + string(move_total_ticks) + ")");

        // Trigger tick flash
        flash_timer = current_time + 150;
        flash_type = "move";

        // Update exact tick-aligned position BEFORE incrementing
        var t = move_ticks_elapsed / move_total_ticks;
        var start = move_target.start_pos;
        var target = move_target.target_pos;

        x = lerp(start.x, target.x, t);
        y = lerp(start.y, target.y, t);

        move_ticks_elapsed++;
		first_tick_bonus = 0;
        if (move_ticks_elapsed >= move_total_ticks) {
            // Final tick — snap to end
            x = target.x;
            y = target.y;
			
			 // Release claimed tile
		    var idx = ds_list_find_index(global.claimed_tile_indices, move_target.tile_index);
		    if (idx != -1) ds_list_delete(global.claimed_tile_indices, idx);
			
            is_moving = false;
            move_target = undefined;
            move_ticks_elapsed = 0;
            move_total_ticks = 0;

            // Trigger arrival flash
            flash_timer = current_time + 300;
            flash_type = "arrive";
        }
    }
}