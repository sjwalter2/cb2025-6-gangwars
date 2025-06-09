function scr_generate_names(filename){
	var names = file_text_open_read(working_directory + filename);
	var nameslist;
	var i = 0;
	while (!file_text_eof(names))
	{
		nameslist[i] = file_text_read_string(names);
		file_text_readln(names);
		i += 1
	}
	file_text_close(names);
	return nameslist;
}