/// @description Gangster

buttonsActivated = false

//Ownership
owner = noone   //Gang ownership
boss = noone //Boss (optional); set to noone if gangster is a toplevel gang member


//Stats
charisma = 0
might = 0
honor = 0


//Display stuff
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))
sprite_head_index = irandom(sprite_get_number(spr_gangsterHead)-1)
image_blend = make_color_rgb(irandom(255),irandom(255),irandom(255));

displayStatsFull = false

money = 0
taxRate = 0.1

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function tick()
{

}


with (instance_create_depth(x+sprite_width+18,y-22,0,obj_buttonInfo))
{
	relativeX = sprite_width+18
	relativeY = -22
	parent=other
}