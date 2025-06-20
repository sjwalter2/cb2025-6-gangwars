//Note: this sample quest can never actually be run. By default, we only run quests if randomly selected from the list of quests in datafiles/quests.txt
/*
Tutorial on how to make a quest:
 - Add a new line to quests.txt. *Make sure not to leave a blank line at the end of the file!!!
 - The line should be a json object of the format at the bottom of this sample script
 - You can copy an existing quest line into a json editor online to help you with parsing
 - create a script in the "quests" group with the same name as "runscript"'s value
 - the "func" argument is the current state/status of the quest.
   - Most often, this represents which button/choice the player made in the quest.
   - We offer up to 4 function buttons; at least 1 is required, and these can be human-readable named (i.e. "func1":"choiceA" allows us to name the cases in a way that is easier to read than just calling it "button1")
   - Note that func does *NOT* have to correspond to a button. It can also represent a state, expectation, etc. This allows us to run arbitrary sets of code in the quest depending on game state.
 
 - Note that once the quest is started, the script runs *every step* until the quest object is destroyed.
*/


//For this sample quest, the player is assigned to capture a random hextile, we'll call HexA. The initial prompt gives them two options:

//TODO: Run arbitrary code *before* prompting the player? Probably requires running this script once with a "setup" case. Not yet implemented, will update the quest objects to do this soon!

//Example of excerpt of json you'd write
//{ ... "button1":"Accept the quest to capture HexA at:", "func1":"Accept","button2": "I dont have time for this.", "func2":"Reject", ... }

function scr_sample_quest(_func){
	
	//Just setting example variables, ignore this
	var HexA = noone;
	var someGangster = noone;
	var myGang = noone;

	//Check what the state of the quest is
	switch _func {
		case "setup":
			//TODO (not implemented yet) You can include a setup func as we will always run this once when the quest is first created.
			//Your script will run once when the obj_quest is first instantiated, allowing you to set some things up. For example, in this sample quest,
			//We might select a random hex to be HexA. Anything you want to display in the quest dialogue box needs to be done here.
			//You might, for example, modify the text of button1 to include the hex coordinates.
			//TODO TODO TODO - this is not implemented yet and might not be implemented by the end of the game jam!
			button1 = string_concat(button1, string(HexA.x), ",", string(HexA.y))
			//If you have nothign you want to set up, it's a good idea to explicitly set a "setup" case anyway.
			//Otherwise your "default" case will run, which you might not want!
			break;
		
		case "Accept":
			//Remind the player of the extant quest
			scr_draw_tooltip_ext(["attack this hex!"],HexA.x,HexA.y)
			
			//Check if quest is completed
			if(HexA.owner == "mygang")
			{
				//Update quest state
				func = "Succeeded"
			}
			break;
			
		case "Reject":
			//Player rejected the quest, pissing off one of the gangsters!
			someGangster.honor -= 20
			show_debug_message("Your crony is angry with you!")

			//obj_quest should probably destroy itself when the quest/event is complete, so make sure to do that at the end of the script. or, if it's a multi-part quest, at the end of the case(s) that end the quest.
			instance_destroy()
			break;

		case "Succeeded":
			//Note: this case is NOT in the JSON, and cannot be accessed by pressing a dialogue box. It is only accessed by code in this very script - the script is self-propelling, allowing the player to progress the quest!
			//Now that the hex is captured, we get rewards
			myGang.money += 100
			someGangster.honor += 5
			show_debug_message("Wow! you are so cool for capturing the hex!")
			//Perhaps show a cool dialogue box?
			
			//obj_quest should probably destroy itself when the quest/event is complete, so make sure to do that at the end of the script. or, if it's a multi-part quest, at the end of the case(s) that end the quest.
			instance_destroy()
			break;
	}

}



///JSON FILE FORMAT
/*
Quests are saved in datafiles/quests.txt
Each line is a separate JSON object, with the following entries:

 name: the quest's name, string, to be displayed at the top
 image: what sprite to use. might be a sprite name, or might be an image_index within a single sprite - to be determined
 description: string containing the quest text
 button1: text for button 1
 button2 (optional): text for button 2
 button3 (optional): text for button 3
 button4 (optional): text for button 4
 runscript: name of script with functions
 func1: name of function to run if button1 is pressed
 func2 (optional): name of function to run if button2 is pressed
 func3 (optional): name of function to run if button3 is pressed
 func4 (optional): name of function to run if button4 is pressed
 defaultFunc: which function is the default if timeout occurs (only takes effect when pause_on_quest=false)


*/