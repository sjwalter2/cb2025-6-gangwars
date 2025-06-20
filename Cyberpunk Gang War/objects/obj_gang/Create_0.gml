/// @description Gang

owner = noone //leave as noone; this is only used for compatibility with scripts
boss = noone //leave as noone; this is only used for compatibility with scripts

testPing = false

money = 0
taxRate = 0.5

//todo: set pawn cost to 0 for now until we can guarantee gangs can claim businesses
pawnCost = 0
//pawnCost = 2

notoriety = 0 //Increases a lot of stuff. This is in percent - so if notoriety=5, a lot of stuff is increased by 5%
gPower = 0 //Abstract representation of firepower, tech, etc - ability to use violence as a force.
pawns = 5 //Total number of assignable pawns
freePawns = 5
assignedPawnsValue = 1.5 //Increase this if the basic foot soldier is upgraded. do this sparingly and wisely as it's a multiplicative!

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
	//todo - uncomment the below once all gangs have businesses? TBD
	//money -= 10 //placeholder - representing general gang cost maintenance. likely to remove or replace this.
	
	if(money < 0)
	{
		money = 0

		//Start losing pawns if the gang is out of cash to pay them

		//Make sure we take pawns that are unassigned before taking pawns from other sources
		//Currently we do it randomly. In a future version, money will be tracked more granularly
		//For example, individual gangsters could fail to pay their pawns (affecting their honor)
		//without it pulling from the gang as a whole.
		//However for now only the gang pays pawn costs, so we will just choose an asset randomly
		freePawns -=1
		if(freePawns < 0)
		{
			freePawns = 0
			if(pawns > 0)
			{
				var eligibleEntities = ds_list_create() //List of all gang entities that can have pawns assigned
				with(obj_business)
				{
					ds_list_add(eligibleEntities,self);
				}
				/*
				with(obj_stronghold)
				{
					ds_list_add(eligibleEntities,self);
				}
				with(obj_gangster)
				{
					ds_list_add(eligibleEntities,self);
				}
				*/
			
				var success = false
				var randomindex = 0
				var testsubject
				while(!success)
				{
					randomindex = irandom(ds_list_size(eligibleEntities)-1)
					testsubject = ds_list_find_value(eligibleEntities,randomindex)
					if(variable_instance_exists(testsubject,"assignedPawns"))
					{
						if(testsubject.assignedPawns > 0)
						{
							testsubject.assignedPawns -= 1
							//TODO: Log!
							success = true
						}
					}
					ds_list_delete(eligibleEntities,randomindex);
					if(ds_list_size(eligibleEntities) == 0 && !success)
					{
						//TODO Send this message to debug before publishing. I want this to interrupt the gaem during dev so we can bugfix but if a bug sneaks through let's not bother the player
						show_message(testsubject.owner.name + " somehow had pawns, that were not free, but were not assigned either!")
						success = true
					}
				}
			
				ds_list_destroy(eligibleEntities)
			}
		}
		
		//Remove from total pawns, regardless of if they were free or assigned
		pawns -= 1
		if(pawns < 0)
		{
			pawns = 0
			show_debug_message("Somehow, we tried to charge Pawn salary, but there were no pawns!")
		}

	}
}

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}
