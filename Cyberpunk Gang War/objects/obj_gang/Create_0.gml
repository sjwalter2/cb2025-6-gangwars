/// @description Gang

owner = noone//leave as noone; this is only used for compatibility with scripts
boss = noone//leave as noone; this is only used for compatibility with scripts

testPing = false

money = 0
taxRate = 0.1

var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist"] 
gangType =  gangTypeList[irandom(array_length(gangTypeList)-1)]

roster = ds_list_create()


var newGangster = instance_create_depth(x,y,0,obj_gangster)
with newGangster {
	owner = other
}
ds_list_add(roster,newGangster)


//Test business - remove this later
with instance_create_depth(x,y,0,obj_business) {
	owner = other
	manager = ds_list_find_value(other.roster,0)
}


function tick() {
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}
