
owner = noone   //Gang ownership; set to noone if neutral
manager = noone //Individual gang manager (optional); set to noone if generally gang managed

name = ""

baseIncome = 100
assignedPawns = 0

adjustedIncome = baseIncome

buttonsActivated = false
displayStatsFull = false

alarm_set(0,20)

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {

	if owner == noone
	{
		show_debug_message("No owner, so nobody profits!");
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
	adjustedIncome = adjustedIncome * (1 + ((assignedPawns/100)*owner.assignedPawnsValue))	
	
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


//Testing buttons
with (instance_create_depth(x+75,y,0,obj_buttonPawn))
{
	relativeX = 75
	relativeY = 0
	parent=other
}

//Testing buttons
with (instance_create_depth(x+75,y+37,0,obj_buttonPawn))
{
	relativeX = 75
	relativeY = 37
	parent=other
	mode="decrease"
}