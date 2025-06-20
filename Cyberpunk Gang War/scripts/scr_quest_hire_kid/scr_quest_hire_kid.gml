//"button1":"They wanted to get caught. Let's see if this kid has potential."
//"button2": "I dont have time for riffraff. Take their tech and boot 'em to the curb."
//"button3":"Must be a spy. Make an example of them."
function scr_quest_hire_kid(_func){
	switch _func {
		case "hire":
			with(obj_eventLogger)
			{
				show_debug_message("You chose to hire the kid");
			}
			instance_destroy()
			break;		
		case "steal":
			with(obj_eventLogger)
			{
				show_debug_message("You chose to steal from the kid");
			}
			instance_destroy()
			break;
		case "kill":
			with(obj_eventLogger)
			{
				show_debug_message("You chose to kill the kid");
			}
			instance_destroy()
			break;
		case "setup":
			if(playerGang != noone)
			{
				description = string_replace(description,"$GANG",playerGang.name)
			}


			break;
	}
}