/// @description Run "setup" case


with(obj_gang)
{
	if !autonomous
	{
		other.playerGang = self
	}
}

//Attach the script to the quest
var script_to_run = asset_get_index(runscript)
if(script_to_run != -1)
{
	myQuest = method(self,script_to_run)
}
else
{
	show_message("Attempted to execute an event that does not exist... " + string(runscript))
}

//If quest is activated, execute setup case
if(is_method(myQuest))
{
	myQuest("setup")
}

alarm[1] = 1

