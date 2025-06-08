
owner = noone   //Gang ownership; set to noone if neutral
manager = noone //Individual gang manager (optional); set to noone if generally gang managed

baseIncome = 100


with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {
	if manager != noone
	{
		with(manager)
		{
			gainMoney(other.baseIncome)
		}
	}
	else if owner != noone
	{
		with(owner)
		{
			gainMoney(other.baseIncome)
		}
	}
	else
	{
		show_debug_message("No owner, so nobody profits!")
	}
}