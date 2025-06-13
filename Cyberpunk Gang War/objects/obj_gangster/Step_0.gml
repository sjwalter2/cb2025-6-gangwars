if ((is_moving || move_queued) && move_target != undefined) {
    var start = move_target.start_pos;
    var target = move_target.target_pos;
    var total_ticks = move_total_ticks;

    var base_tick = is_moving ? move_ticks_elapsed : 0;
    var tick_progress = 0;


    
    // Blend current tick and one full tick for the first animation leg
    var time = global.time;

	if(move_queued)
	{	
		time  -=	(global.tickTime - first_tick_bonus) 
	}
	else if(first_tick_bonus != 0)
		time += first_tick_bonus
			
    tick_progress = time / (global.tickTime + first_tick_bonus);


    var t = (base_tick + tick_progress) / total_ticks;
    t = clamp(t, 0, 1);

    x = lerp(start.x, target.x, t);
    y = lerp(start.y, target.y, t);
}



// Skip if not idle or not part of a gang
if (startGame == 1 || state != "idle" || owner == noone) exit;

// Get current tile
var my_axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
var start_key = string(my_axial.q) + "," + string(my_axial.r);
if (!ds_map_exists(global.hex_lookup, start_key)) exit;

var start_tile_index = global.hex_lookup[? start_key];
var start_tile = global.hex_grid[start_tile_index];

// Get all tiles the gang can target
var gang_name = owner.name;
var targetable_tiles = scr_get_targetable_tiles(gang_name);



// Pick closest target tile by movement cost (AI decision)
var target_index = scr_gangster_ai_decide_target(self);

if (target_index == -1 || !is_real(target_index)) exit;
var goal_tile = global.hex_grid[target_index];

// Build path using A*
var path = scr_hex_a_star_path(my_axial.q, my_axial.r, goal_tile.q, goal_tile.r, owner.name);

// Start movement if path is valid
if (is_array(path) && array_length(path) > 0) {
    if (array_length(path) == 0) exit;

	self.move_path = path;
	self.has_followup_move = true;

	var first_step = array_shift(self.move_path);
	if (array_length(self.move_path) == 0) self.has_followup_move = false;

	scr_gangster_start_movement(self, first_step, true);

}

