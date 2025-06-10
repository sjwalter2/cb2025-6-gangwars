/// Make sure parent remains activated when button is pressed

if(ds_list_find_index(global.selected,parent) == -1)
{
	ds_list_add(global.selected,parent)
}
parent.buttonsActivated = true