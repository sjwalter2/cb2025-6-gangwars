/// @description Gang

testPing = false

money = 0

gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist"] 
gangType =  gangTypeList[irandom(array_length(gangTypeList)-1)]

with instance_create_depth(x,y,0,obj_business) {
	owner = other
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick() {
}