
with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {
	owner.money += irandom(20)
}