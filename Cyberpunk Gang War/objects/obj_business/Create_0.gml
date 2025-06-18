
owner = noone   //Gang ownership; set to noone if neutral
manager = noone //Individual gang manager (optional); set to noone if generally gang managed

baseIncome = 10
assignedPawns = 0
maxPawns = 6

adjustedIncome = baseIncome

buttonsActivated = false
displayStatsFull = false

tile_index = -1;        // Tile index on the hex grid
q = -1
r = -1

// === UNIQUE NAME GENERATION ===
name = "";


if (!variable_global_exists("businessAdjectives")) {
	global.businessAdjectives = scr_generate_names("businessadjectives.txt");
}

if (!variable_global_exists("businessNouns")) {
	global.businessNouns = scr_generate_names("businessnouns.txt");
}

if (!variable_global_exists("used_business_names")) {
	global.used_business_names = [];
}


repeat (100) { // Cap attempts to avoid infinite loop
	var adj = scr_get_name(global.businessAdjectives);
	var noun = scr_get_name(global.businessNouns);
	var try_name = adj + " " + noun;

	var is_unique = true;
	for (var i = 0; i < array_length(global.used_business_names); i++) {
	    if (global.used_business_names[i] == try_name) {
	        is_unique = false;
	        break;
	    }
	}

	if (is_unique) {
	    name = try_name;
	    array_push(global.used_business_names, name);
	    break;
	}
}



with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {

	if owner == noone
	{
		//show_debug_message("No owner, so nobody profits!");
		exit;
	}

	
	adjustedIncome = baseIncome

	
	/*
	//Reduce income by corporate control percentage
	adjustedIncome = baseIncome * ((100-neighborhoodCorpoliceControl)/100)

	//Increase income by gang notoriety *if* gang owns neighborhood
	if neighborhood.highestInfluence == owner {
		adjustedIncome = adjustedIncome * (1 + (owner.notoriety/100))
	}

	*/
	//Assigned pawns increase income by 1% each, unless the gang has upgraded pawns, in which case assignedPawnsValue will increase	
	adjustedIncome = adjustedIncome * (1 + ((assignedPawns/2)*owner.assignedPawnsValue)) //Example. PawnsValue = 1.5, PawnCost = 2, baseIncome = 10. Adding 4 pawns would increase income by 300%, for an additional $30, minus the $8 cost of the pawns.
	
	if manager != noone
	{
		adjustedIncome = adjustedIncome * (1 + (manager.charisma/100))
		with(manager)
		{
			scr_gain_money(other.adjustedIncome)
		}
	}
	else
	{
		with(owner)
		{
			scr_gain_money(other.adjustedIncome)
		}
	}
}


/*
//Testing buttons
with (instance_create_depth(x-37,y,0,obj_buttonVariableChanger))
{
	relativeX = -37
	relativeY = 0
	variable="baseIncome"
	parent=other
}

//Testing buttons
with (instance_create_depth(x-37,y+37,0,obj_buttonVariableChanger))
{
	relativeX = -37
	relativeY = 37
	variable="baseIncome"
	parent=other
	mode="decrease"
}
*/

//Testing buttons
with (instance_create_depth(x+18,y-10,0,obj_buttonPawn))
{
	parent=other
	relativeX = 18
	relativeY = -10
}

//Testing buttons
with (instance_create_depth(x+18,y+10,0,obj_buttonPawn))
{
	relativeX = 18
	relativeY = 10
	parent=other
	mode="decrease"
}