if(array_length(currentShelf) == 0)
{
	exit;
}


for (var i = 0 ; i < array_length(currentShelf); i+= 1)
{
	currentShelf[i].guiY = guiY+(currentShelf[i].sprite_height +lineHeight)*i
	currentShelf[i].guiX = guiX
	currentShelf[i].shelfActive = true
}

shelfHeight = (currentShelf[0].sprite_height+lineHeight) * array_length(currentShelf) +18
