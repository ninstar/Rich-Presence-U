/// @description Start program

// Mandatory update
if(Version < global.NET_UPDATE_Version)
&&(Version < global.NET_UPDATE_Minimal){

	var _GetUpdate = show_question(global.OutputMessage[? "Update_Mandatory"]);
	
	if(_GetUpdate == 1)
		url_open(global.NET_UPDATE_Page);
	
	game_end();
}
else
	instance_create_depth(0, 0, depth+1, oProgram);