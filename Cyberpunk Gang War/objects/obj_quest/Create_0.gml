// NOTE: variables are set by the "struct" part of instance_create_ functions. we set defaults in Variable Definitions instead of in Create event because of event order reasons

alarm[0] = 1

//dialogue box
displayReady = false
display_outer_rect_direction = 1
display_outer_rect = 0

//this will get set to a method-variable referencing the script in runscript; usually it gets set by obj_buttonQuest
//since all events only start when the player clicks a button in the dialogue, we dont actually assign the script until they've made that choice
//note that once activated, we run the "quest" script *every step*, so if the quest is on-going, make sure to use "if" statements to check for conditions or etc
myQuest = noone
func = ""