/// @description Gang

owner = noone //leave as noone; this is only used for compatibility with scripts
boss = noone //leave as noone; this is only used for compatibility with scripts

testPing = false

money = 0
taxRate = 0.5

notoriety = 0 //Increases a lot of stuff. This is in percent - so if notoriety=5, a lot of stuff is increased by 5%
gPower = 0 //Abstract representation of firepower, tech, etc - ability to use violence as a force.
pawns = 5 //Total number of assignable pawns
assignedPawnsValue = 1 //Increase this if the basic foot soldier is upgraded. do this sparingly and wisely as it's a multiplicative!

var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist","Nomad"] 
gangType =  gangTypeList[irandom(array_length(gangTypeList)-1)]

roster = ds_list_create()

for (var j = 0 ; j < 2 ; j+= 1) {
	var newGangster = instance_create_depth(x,y+(40*(j+1)),0,obj_gangster)
	with newGangster {
		owner = other
	}
	ds_list_add(roster,newGangster)
}

////Test business - remove this later
//with instance_create_depth(x,y + 200,0,obj_business) {
//	owner = other
//	manager = ds_list_find_value(other.roster,0)
//}

//Testing buttons
with (instance_create_depth(x-37,y,0,obj_button))
{
	variable="notoriety"
	parent=other
}

//Testing buttons
with (instance_create_depth(x-37,y+37,0,obj_button))
{
	variable="notoriety"
	parent=other
	mode="decrease"
}



function tick() {
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}
