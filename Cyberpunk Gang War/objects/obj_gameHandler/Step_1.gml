ds_map_clear(global.gangster_tile_map);
ds_map_clear(global.tile_reservations);
with(obj_gangster)
{
	var axial = scr_pixel_to_axial(x - global.offsetX, y - global.offsetY);
	var key = scr_axial_key(axial.q, axial.r);
	global.gangster_tile_map[? key] = id;	
}