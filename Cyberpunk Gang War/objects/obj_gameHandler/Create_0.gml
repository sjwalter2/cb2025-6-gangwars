///Initialize global lists
global.debugMode = true;
global.firstnames = scr_generate_names("firstnames.txt")

global.selected = ds_list_create()
global.selection_cooldown = false;
global.tooltip_boxes_drawn = [];
global.claimed_tile_indices = ds_list_create();

global.gangster_thinking_queue = ds_queue_create();
global.gangster_tile_map = ds_map_create();
global.tile_reservations = ds_map_create();

global.fps_history = ds_queue_create();
global.fps_timer = current_time;
global.fps_worst_10s = fps; // Start with current fps
global.fps_avg_10s = fps;


//Initialize GUI flags and objects
global.displayGangsterStatsFull = false
global.displayGangStatsFull = true
gui_button_shelf = instance_create_depth(0,0,0,obj_gui_button_shelf)
gui_button_shelf.lineHeight = 18
gui_button_pause = instance_create_layer(-100,-100,"UI",obj_buttonSpeedGui)


///Initialize games
tickers = ds_list_create()

global.cost_friendly  = 2;
global.cost_unclaimed  = 3;
global.cost_enemy    = 4;

global.resupply_tile_limit = 2;   // tiles gangster can capture before resupplying
global.resupply_tick_cost = 2;    // how long they must wait to resupply

global.intervene_fail_chance_with_capture = 0.7;  // 70% chance to fail if intervention used a capture
global.intervene_fail_chance_without_capture = 0.3;  // 30% chance to fail if intervention had no capture left


randomize()

//Handle per-turn flags
global.buttonPressed = false

///Handle timers
nextSpeed = 1
global.currentSpeed = 1 //values: 0, 1, 2
global.time = 0

global.tickTime = 30
totalTicks = 0

//Tick Cost
moveFriendly = 2
moveUnowned = 3
moveEnemy = 4

function tick() {
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}
