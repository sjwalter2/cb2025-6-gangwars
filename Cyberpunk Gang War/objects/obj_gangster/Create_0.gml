/// @description Gangster

owner = noone   //Gang ownership
boss = noone //Boss (optional); set to noone if gangster is a toplevel gang member

name = "Default Name"

money = 0
taxRate = 0.1

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick()
{

}

