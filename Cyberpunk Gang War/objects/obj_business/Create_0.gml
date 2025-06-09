
owner = noone   //Gang ownership; set to noone if neutral
manager = noone //Individual gang manager (optional); set to noone if generally gang managed

baseIncome = 100


with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {

	if owner == noone
	{
		show_debug_message("No owner, so nobody profits!");
		break;
	}

	
	var adjustedIncome = baseIncome

	
	/*
	//Reduce income by corporate control percentage
	adjustedIncome = baseIncome * ((100-neighborhoodCorpoliceControl)/100)

	//Increase income by gang notoriety *if* gang owns neighborhood
	if neighborhood.highestInfluence == owner {
		adjustedIncome = adjustedIncome * (1 + (owner.notoriety/100))
	}

	//Assigned pawns increase income by 1% each, unless the gang has upgraded pawns, in which case assignedPawnsValue will increase	
	adjustedIncome = adjustedIncome * (1 + ((assignedPawns/100)*owner.assignedPawnsValue))
	
	*/
	
	
	if manager != noone
	{
		adjustedIncome = adjustedIncome * (1 + (manager.charisma/100))
		with(manager)
		{
			scr_get_money(other.baseIncome)
		}
	}
	else
	{
		with(owner)
		{
			scr_get_money(other.baseIncome)
		}
	}
}