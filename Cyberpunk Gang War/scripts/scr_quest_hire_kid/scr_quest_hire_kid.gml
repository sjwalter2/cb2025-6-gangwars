//"button1":"They wanted to get caught. Let's see if this kid has potential."
//"button2": "I dont have time for riffraff. Take their tech and boot 'em to the curb."
//"button3":"Must be a spy. Make an example of them."
function scr_quest_hire_kid(_func){
	switch _func {
		case "hire":
			show_message("You chose to hire the kid")
			break;		
		case "steal":
			show_message("You chose to steal from the kid")
			break;
		case "kill":
			show_message("You chose to kill the kid")
			break;
	}
	instance_destroy()
}