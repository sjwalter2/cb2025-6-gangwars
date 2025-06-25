
//Info Shelf
var nextBut = instance_create_depth(-100,-100,0,obj_buttonNextShelf)
with nextBut
{
	nextShelf = other.gangShelf
}

var questRandBut = instance_create_depth(-100,-100,0,obj_buttonGlobalTrueFalse)
with questRandBut
{
	variable = "questsRandom"
	text = "Randomly select quest"
}

var questActiveBut = instance_create_depth(-100,-100,0,obj_buttonGlobalTrueFalse)
with questActiveBut
{
	variable = "questsActive"
	text = "Quests active"
}

displayShelf = [instance_create_depth(-100,-100,0,obj_buttonGlobalGangsterInfo),instance_create_depth(-100,-100,0,obj_buttonGlobalGangInfo),instance_create_depth(-100,-100,0,obj_buttonSpawnQuestGui),questActiveBut,questRandBut,nextBut]

currentShelf = displayShelf
currentParentShelf = displayShelf