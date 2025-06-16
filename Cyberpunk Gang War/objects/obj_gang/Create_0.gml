/// @description Gang

owner = noone //leave as noone; this is only used for compatibility with scripts
boss = noone //leave as noone; this is only used for compatibility with scripts

testPing = false

money = 0
taxRate = 0.5
pawnCost = 1

notoriety = 0 //Increases a lot of stuff. This is in percent - so if notoriety=5, a lot of stuff is increased by 5%
gPower = 0 //Abstract representation of firepower, tech, etc - ability to use violence as a force.
pawns = 5 //Total number of assignable pawns
freePawns = 5
assignedPawnsValue = 1 //Increase this if the basic foot soldier is upgraded. do this sparingly and wisely as it's a multiplicative!

var gangTypeList = ["Yakuza","Biker","Mafia","Hacker","Cyborg","Clown","Communist","Nomad"] 
gangType =  gangTypeList[irandom(array_length(gangTypeList)-1)]

roster = ds_list_create()


////Test business - remove this later
//with instance_create_depth(x,y + 200,0,obj_business) {
//	owner = other
//	manager = ds_list_find_value(other.roster,0)
//}

//Testing buttons
//with (instance_create_depth(x-37,y,0,obj_button))
//{
//	variable="notoriety"
//	parent=other
//}

////Testing buttons
//with (instance_create_depth(x-37,y+37,0,obj_button))
//{
//	variable="notoriety"
//	parent=other
//	mode="decrease"
//}



function tick() {
	
	//Must pay pawns their salary!
	money -= pawns*pawnCost
	
	if(money < 0)
	{
		//Start losing pawns if the gang is out of cash to pay them
		pawns -= 1
		if(pawns < 0)
		{
			pawns = 0
			show_message("Somehow, we tried to charge Pawn salary, but there were no pawns!")
		}
		
		//Make sure we take pawns that are unassigned before taking pawns from other sources
		freePawns -=1

		if(pawns > 0 && freePawns < 0)
		{
			freePawns = 0
			//TODO: Remove assigned pawns since there were no unassigned pawns to remove.
			//Currently, the logic does not make sense, since gang's pawn count will go down but could actually have assigned pawns
		}

		money = 0
	}
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}
