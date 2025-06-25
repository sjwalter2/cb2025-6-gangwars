
var nextBut = instance_create_depth(-100,-100,0,obj_buttonNextShelf)
with nextBut
{
	nextShelf = other.displayShelf
}

for (var i = 0 ; i < instance_number(obj_gang) ; i += 1)
{
	array_push(gangShelf,instance_create_depth(-100,-100,0,obj_buttonGangInfo))
	gangShelf[i].gang = instance_find(obj_gang,i)
	gangShelf[i].text = gangShelf[i].gang.name
}

array_push(gangShelf,nextBut)

