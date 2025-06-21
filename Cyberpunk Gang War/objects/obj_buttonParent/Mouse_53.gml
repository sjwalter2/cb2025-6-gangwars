if(global.inputLocked) exit;
else
{
	if (ds_exists(global.selected, ds_type_list)) {
	    for (var i = 0; i < ds_list_size(global.selected); i++) {
	        var inst = global.selected[| i];
	        if (instance_exists(inst) && variable_instance_exists(inst, "name") && parent != noone) {
	            if inst.name == parent.name {
					_activated = true
					exit;
				}
			}
		}
	}
	_activated = false
}