//-----------------------------------------------------\\
/*

For a tutorial on how to add quests, please see the tutorial in script "scr_sample_quest"

obj_questHandler is in charge of creating obj_quest instances
obj_quest creates dialogue boxes for players to make choices; it then is assigned a script, which it proceeds to run every Step
obj_buttonQuest is created by obj_quest; it's given text and a function argument called "func" (like a mini function name? idk), which gets passed into obj_quest

Because text is memory-cheap, at game start, we load all above quest details into a ds_list, which gets ds_list_shuffle'd
When a quest is required, we pop a value from the ds_list and create an obj_quest with the same.
Note: we create an obj_quest because some quests are not instantaneous/have longterm effects/require player to make some effects happen.1

*/

//is used to manually spawn a quest
global.spawnQuest = false
if(!variable_global_exists("questsActive"))
{
	global.questsActive = true;
}

if(!variable_global_exists("questsRandom"))
{
	global.questsRandom = false
}


quests_list = ds_list_create()

var quests = file_text_open_read(working_directory + "quests.txt");
while (!file_text_eof(quests))
{
	ds_list_add(quests_list,file_text_read_string(quests));
	file_text_readln(quests);
}
file_text_close(quests);

//TODO: make a quest journal for completed events?
//TODO: make the quests time out after a while so the player has to choose fast

pause_on_quest = true

with(obj_gameHandler)
{
	ds_list_add(tickers,other)	
}

min_ticks_between_quests = 30
current_tick_count = 0
base_quest_chance=0.20
quest_chance_increase_amount = 0.05 //Percent increase chance of a quest for each tick that goes by above the min

function tick()
{
	if( global.questsActive == false )
	{
		exit;
	}
	
	if(ds_list_size(quests_list) <= 0)
	{
		//show_debug_message("Ran out of new quests. Have a nice day!")
		exit;
	}
	current_tick_count += 1
	
	//Make sure no quest dialogues are already active
	if instance_number(obj_buttonQuest) > 0
		exit;
		
	//Make sure no quests are preparing to prompt
	var toExit = false
	with(obj_quest)
	{
		if alarm[0] > 0 || alarm[1] > 0
			toExit = true
	}
	
	if toExit
		exit;
	
	if current_tick_count >= min_ticks_between_quests || global.spawnQuest == true
	{
		var test_for_quest = base_quest_chance + (current_tick_count-min_ticks_between_quests)*quest_chance_increase_amount
		var _rand = random(1)
		if _rand < test_for_quest || global.spawnQuest == true //We quest!
		{
			current_tick_count = 0
			global.spawnQuest = false
			
			if(global.questsRandom)
			{
				//Choose a random quest from the list
				var _questNum = irandom(ds_list_size(quests_list)-1)
			} else
			{
				//Choose quests in reverse list order (last entry in quests.txt is read first, etc)
				var _questNum = ds_list_size(quests_list)-1
			}

			var _questJSON = json_parse(ds_list_find_value(quests_list,_questNum))
			ds_list_delete(quests_list,_questNum)
			
			//Create the quest with the associated JSON
			instance_create_layer(x,y,"UI",obj_quest,_questJSON)
			
		}
		else
		{
			exit;
		}
	}
}
