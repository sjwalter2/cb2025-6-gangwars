///Initialize global lists

global.firstnames = scr_generate_names("firstnames.txt")


///Initialize games
tickers = ds_list_create()


randomize()
instance_create_layer(50,100,"Instances",obj_gang)
instance_create_layer(450,100,"Instances",obj_gang)
instance_create_layer(850,100,"Instances",obj_gang)


///Handle timers
currentSpeed = 1 //values: 0, 1, 2
time = 0

tickTime = 120 //Time in frames between game logic "ticks" (note: 60 = 1 second)


