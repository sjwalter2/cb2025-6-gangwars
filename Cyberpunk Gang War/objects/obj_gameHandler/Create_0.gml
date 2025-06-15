///Initialize global lists
global.debugMode = true;
global.firstnames = scr_generate_names("firstnames.txt")
global.selected = ds_list_create()
global.selection_cooldown = false;
global.tooltip_boxes_drawn = [];
global.claimed_tile_indices = ds_list_create();

//Initialize GUI flags and objects
global.displayGangsterStatsFull = false
global.displayGangStatsFull = true
gui_button_shelf = instance_create_depth(0,0,0,obj_gui_button_shelf)
gui_button_shelf.lineHeight = 18

///Initialize games
tickers = ds_list_create()

global.cost_friendly  = 2;
global.cost_unclaimed  = 3;
global.cost_enemy    = 4;



randomize()

//Handle per-turn flags
global.buttonPressed = false

///Handle timers
nextSpeed = 1
global.currentSpeed = 1 //values: 0, 1, 2
global.time = 0

global.tickTime = 60
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
