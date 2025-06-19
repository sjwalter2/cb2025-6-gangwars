//TODO: write script that pops up the dialogue
//TODO: create quest script group
//TODO: create a couple basic quest script templates
//TODO: create a method to get player's gang specifically, set to a variable
//TODO: make a way to quickly test scripts without relying on quest spawner
//TODO: make a quick way to create json quests

with(obj_gameHandler)
{
	ds_list_add(tickers,other)	
}

function tick()
{
	//TODO: check if it's been long enough since the last quest
	//TODO: randomize chance of quest to make it a non-regular cadence
	//TODO: pause game
	//TODO: pop a value from ds_list quests
	//TODO: parse the json into an array of values
	//TODO: pass key:value's to the obj_quest
	//TODO: pass player gang to the obj_quest so it knows what gang is player-controlled
	//TODO: when chained quests are created, we'll need to revisit this!
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
 script1: name of script to run if button1 is pressed
 script2 (optional): name of script to run if button2 is pressed
 script3 (optional): name of script to run if button3 is pressed
 script4 (optional): name of script to run if button4 is pressed

Because text is memory-cheap, at game start, we load all above quest details into a ds_list, which gets ds_list_shuffle'd
When a quest is required, we pop a value from the ds_list and create an obj_quest with the same.
Note: we create an obj_quest because some quests are not instantaneous/have longterm effects/require player to make some effects happen.
obj_quest destroys itself when the quest is complete.
//TODO: make a quest journal for completed events?

*/