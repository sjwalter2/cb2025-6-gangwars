time = time + currentSpeed
if time >= tickTime {
	time = 0
	for (var i = 0; i < ds_list_size(tickers); i++)
	with(ds_list_find_value(tickers,i)) {
		tick()
	}
}