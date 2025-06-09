
//Return a random name from the array passed in
function scr_get_name(nameslist){
	if array_length(nameslist) == 0
	{
		return "EmptyList!"
	}
	else
	{
		var i = irandom(array_length(nameslist)-1)
		return nameslist[i]
	}
}