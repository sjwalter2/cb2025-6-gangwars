/// @description display "dialogue box" and create all relevant choice buttons

//Before creating a dialogue box, make sure an existing one is not already present. The quests break if multiple spawn dialogue boxes at once!
if(instance_exists(obj_buttonQuest)){
	alarm[1] = 1
	exit;
}


//Either pause game or set to slowest speed when a quest starts
with(obj_questHandler)
{
	//Either pause game, or set it to the slowest non-paused speed
	if(pause_on_quest)
	{
		with(obj_gameHandler)
		{
			nextSpeed = 0
		}
	} else
	{
		with(obj_gameHandler)
		{
			nextSpeed = 1
		}	
	}
}

if(button1 != "")
{
	with instance_create_layer(_width*0.333,_height*0.666,"questButtons",obj_buttonQuest)
	{
		parent = other
		myFunction = other.func1
		text = other.button1
		shelfActive = true
		
		guiX = x
		guiY = y
	}
}
if(button2 != "")
{
	with instance_create_layer(_width*0.666,_height*0.666,"questButtons",obj_buttonQuest)
	{
		parent = other
		myFunction = other.func2
		text = other.button2
		shelfActive = true
		guiX = x
		guiY = y
	}
}
if(button3 != "")
{
	with instance_create_layer(_width*0.333,_height*0.722,"questButtons",obj_buttonQuest)
	{
		parent = other
		myFunction = other.func3
		text = other.button3
		shelfActive = true
		
		guiX = x
		guiY = y
	}
}
if(button4 != "")
{
	with instance_create_layer(_width*0.666,_height*0.722,"questButtons",obj_buttonQuest)
	{
		parent = other
		myFunction = other.func4
		text = other.button4
		shelfActive = true
		
		guiX = x
		guiY = y
	}
}

displayReady = true