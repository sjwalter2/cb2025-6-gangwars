//"button1":"They wanted to get caught. Let's see if this kid has potential."
//"button2": "I dont have time for riffraff. Take their tech and boot 'em to the curb."
//"button3":"Must be a spy. Make an example of them."
function scr_quest_hire_kid(_func){
	switch _func {
		//=============================================================================================================
		case "hire":
			if(playerGang != noone)
			{
				var new_gangster = scr_hire_gangster(playerGang)
				if (new_gangster == 0)
				{
					func = "confirm"
					description = "The kid skiddadled... Either we dont have a stronghold, or something else went wrong..."
					displayReady = true
					with instance_create_layer(_width*0.5,_height*0.666,"questButtons",obj_buttonQuest)
					{
						parent = other
						myFunction = "end"
						text = "Ok"
						shelfActive = true
						guiX = x
						guiY = y
					}
				} else {
					func = "confirm"
					description = "You've agreed to hire on " + new_gangster.name + ", at least on a trial basis"
					displayReady = true
					with instance_create_layer(_width*0.5,_height*0.666,"questButtons",obj_buttonQuest)
					{
						parent = other
						myFunction = "end"
						text = "Ok"
						shelfActive = true
						guiX = x
						guiY = y
					}
				}
			} else {
				show_message("playerGang not set!")
				instance_destroy()
			}
			break;		
		//=============================================================================================================
		case "steal":

			if(playerGang != noone)
			{
				var gainedCash = irandom_range(400,800)
				with(playerGang)
				{
					scr_gain_money(gainedCash)
				}
				func = "confirm"
				description = "We shook the kid down for " + string(gainedCash) + " bucks. Sucks to be them!"
				displayReady = true
				with instance_create_layer(_width*0.5,_height*0.666,"questButtons",obj_buttonQuest)
				{
					parent = other
					myFunction = "end"
					text = "Ok"
					shelfActive = true
					guiX = x
					guiY = y
				}
			} else {
				show_message("playerGang not set!")
				instance_destroy()
			}

			break;
		//=============================================================================================================
		case "kill":

			if(playerGang != noone)
			{
				var gainedNotoriety = 5
				with(playerGang)
				{
					notoriety += gainedNotoriety
				}
				func = "confirm"
				description = "Nobody messes with the " + playerGang.name + ". Gained " + string(gainedNotoriety) + " notoriety. Poor kid..."
				displayReady = true
				with instance_create_layer(_width*0.5,_height*0.666,"questButtons",obj_buttonQuest)
				{
					parent = other
					myFunction = "end"
					text = "Ok"
					shelfActive = true
					guiX = x
					guiY = y
				}
			} else {
				show_message("playerGang not set!")
				instance_destroy()
			}

			break;
		//=============================================================================================================
		case "setup":
			if(playerGang != noone)
			{
				description = string_replace(description,"$GANG",playerGang.name)
			}
			break;
		//=============================================================================================================
		case "end":
			instance_destroy()
			break;
	}
}