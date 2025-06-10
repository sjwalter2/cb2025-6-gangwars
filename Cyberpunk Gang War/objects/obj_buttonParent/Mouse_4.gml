_activated = false
if(variable_instance_exists(parent,"buttonsActivated")) {
	if(parent.buttonsActivated == true) {
		_activated = true
		alarm[0] = 1
	}
} else {
	_activated = true
}

