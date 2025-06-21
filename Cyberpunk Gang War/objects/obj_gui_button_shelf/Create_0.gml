guiY = 0
guiX = 10
shelfHeight = 0

lineHeight = 0

gangShelf = []


//Info Shelf
var nextBut = instance_create_depth(-100,-100,0,obj_buttonNextShelf)
with nextBut
{
	nextShelf = other.gangShelf
}
displayShelf = [instance_create_depth(-100,-100,0,obj_buttonGlobalGangsterInfo),instance_create_depth(-100,-100,0,obj_buttonGlobalGangInfo),instance_create_depth(-100,-100,0,obj_buttonSpawnQuestGui),nextBut]

//Gang Shelf
alarm[0] = 1

currentShelf = displayShelf
currentParentShelf = displayShelf

function changeShelf(shelf)
{
	for(var i = 0; i < array_length(currentShelf); i+= 1)
	{
		with(currentShelf[i]) {
			shelfActive = false
		}
	}
	currentShelf = shelf
}

function createShelf(buttonArray)
{
	array_push(buttonArray,instance_create_depth(-100,-100,0,obj_buttonReturnGui))
	changeShelf(buttonArray)
}