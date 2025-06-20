/// @description Display "dialogue box" and create all relevant choice buttons

var _width = camera_get_view_width(view_camera[0])
var _height = camera_get_view_height(view_camera[0])


if(button1 != "")
{
	with instance_create_layer(_width*0.333,_height*0.555,"questButtons",obj_buttonQuest)
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
	with instance_create_layer(_width*0.666,_height*0.555,"questButtons",obj_buttonQuest)
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
	with instance_create_layer(_width*0.333,_height*0.666,"questButtons",obj_buttonQuest)
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
	with instance_create_layer(_width*0.666,_height*0.666,"questButtons",obj_buttonQuest)
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