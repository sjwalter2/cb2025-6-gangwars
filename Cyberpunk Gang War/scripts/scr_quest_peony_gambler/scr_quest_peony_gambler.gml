function scr_quest_peony_gambler(_func){
	
	switch _func {
		//=============================================================================================================
		case "giveup":
			if(playerGang.pawns <= 0)
			{
				
			}
			else
			{
				with(playerGang)
				{
					lose_pawn()
				}
				pawnCount = playerGang.pawns
				oldPawnCost = playerGang.hirePawnCost
				playerGang.hirePawnCost = playerGang.hirePawnCost * 4
				newPawnsHired = 0
				func = "confirm"
				description = "It's awkward to give up our own man, but it'll be worse if the situation escalates with " + rivalGang.name + ". We'll need to spend a bit more to convince new recruits we're worth joining..."
				displayReady = true
				with instance_create_layer(_width*0.5,_height*0.555,"questButtons",obj_buttonQuest)
				{
					parent = other
					myFunction = "pawnCostIncrease"
					text = "Ok"
					shelfActive = true
					guiX = x
					guiY = y
				}
			}
		break;
		//=============================================================================================================
		case "pawnCostIncrease":
			if(playerGang.pawns < pawnCount)
			{
				pawnCount = playerGang.pawns
			} else if (playerGang.pawns > pawnCount)
			{
				newPawnsHired += 1
				pawnCount = playerGang.pawns
				if(newPawnsHired >= 3)
				{
					playerGang.hirePawnCost = oldPawnCost
					instance_destroy()
				}
			}
		
			break;
		//=============================================================================================================
		case "war":
			var newGangster = scr_hire_gangster(rivalGang)
			func = "confirm"
			description = "Our refusal has bolstered the resolve of the Peony Gambler's follower " + newGangster.name + ", who has joined " + rivalGang.name + "."
			displayReady = true
			with instance_create_layer(_width*0.5,_height*0.555,"questButtons",obj_buttonQuest)
			{
				parent = other
				myFunction = "end"
				text = "The fool!"
				shelfActive = true
				guiX = x
				guiY = y
			}

			break;
		//=============================================================================================================
		case "wait":
			if waited == true
			{
				func = "war"
			} else {
				ticksWaited = 0
				with(obj_gameHandler)
				{
					ds_list_add(tickers,other)
				}
				function tick()
				{
					ticksWaited += 1
				}
				func = "waiting"
			}
			break;
		//=============================================================================================================
		case "waiting":
			if(ticksWaited >= 60)
			{
				with(obj_gameHandler)
				{
					ds_list_delete(tickers,ds_list_find_index(tickers,other))
				}
				alarm[1] = 1
				func = "confirm"
				description = "The Peony Gambler has demanded an answer. Waiting longer is tantamount to war with " + rivalGang.name + " who still shelter her."
				waited = true
			}
		
			break;
		//=============================================================================================================
		case "bribe":
		
			if(playerGang.money >= 150)
			{
				playerGang.money -= 150
				func = "confirm"
				description = "It didn't take much to convince " + rivalGang.name + " to send the Peony Gambler off on a wild goose chase in another city. Perhaps cold cash is more powerful than justice..."
				displayReady = true
				with instance_create_layer(_width*0.5,_height*0.555,"questButtons",obj_buttonQuest)
				{
					parent = other
					myFunction = "end"
					text = "We live in a new age..."
					shelfActive = true
					guiX = x
					guiY = y
				}
			} else {
				func = "confirm"
				description = "Maybe insulting " + rivalGang.name + " with the promise of a bribe we can't afford isn't such a bright idea."
				alarm[1] = 1
			}
			break;
		//=============================================================================================================
		case "setup":
			if(playerGang != noone)
			{
				var randomGangTerritory = global.gang_territories[irandom(array_length(global.gang_territories)-1)]
				var attempts = 0
				//Set attempts to 100 to not stall the game -- extremely rare but will always occur if only 1 gang left for some reason
				while(randomGangTerritory.name == playerGang.name && attempts < 100)
				{
					randomGangTerritory = global.gang_territories[irandom(array_length(global.gang_territories)-1)]
				}
				if(randomGangTerritory.name == playerGang.name){
					instance_destroy()
					exit
				}
				
				rivalGang = noone
				with(obj_gang)
				{
					if name = randomGangTerritory.name
					{
						other.rivalGang = self
					}
				}
				if(rivalGang == noone)
				{
					show_debug_message("WARNING: Couldnt find rival gang")
					instance_destroy()
					exit
				}
				description = string_replace(description,"$ENEMYGANG",rivalGang.name)
				waited = false
			} else {
				show_debug_message("WARNING: Couldnt find player gang!")
				instance_destroy()
			}
			break;
		//=============================================================================================================
		case "end":
			instance_destroy()
			break;
	}
}