/// @description Gangster

owner = noone   //Gang ownership
boss = noone //Boss (optional); set to noone if gangster is a toplevel gang member
draw_gui = 0;
//Stats
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))

charisma = 0
might = 0
honor = 0

//Display stuff
name = scr_get_name(global.firstnames) + " " + chr(irandom_range(ord("A"),ord("Z")))
sprite_head_index = irandom(sprite_get_number(spr_gangsterHead)-1)
image_blend = make_color_rgb(irandom(255),irandom(255),irandom(255));

displayStatsFull = false
show_debug_message(name)

money = 0
taxRate = 0.1

with(obj_gameHandler) {
	ds_list_add(tickers,other)
}

function draw_polygon(cx, cy, radius, sides) {
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(cx, cy);
    for (var i = 0; i <= sides; i++) {
        var angle = degtorad(i * 360 / sides);
        var px = cx + cos(angle) * radius;
        var py = cy + sin(angle) * radius;
        draw_vertex(px, py);
    }
    draw_primitive_end();
}

//with (instance_create_depth(x+sprite_width+18,y-22,0,obj_buttonInfo))
//{
//	relativeX = sprite_width+18
//	relativeY = -22
//	parent=other
//}
