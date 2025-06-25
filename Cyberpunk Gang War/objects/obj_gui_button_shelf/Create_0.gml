guiY = 0
guiX = 10
shelfHeight = 0

lineHeight = 0

gangShelf = []
displayShelf = []

//Gang Shelf
alarm[0] = 1
alarm[1] = 2

currentShelf = []
currentParentShelf = []

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