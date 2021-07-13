/// @description Check app update
ini_open(game_save_id+"database.cfg");

Link_Page = ini_read_string("web", "default", "https://");

var _Update_Version = ini_read_string("version", "current", version_int);
var _Update_Minimal = ini_read_string("version", "minimal", version_int);
var _Update_Link = ini_read_string("version", "page", "https://");

ini_close();

if(real(_Update_Version) > version_int){

	AppUpdate = true;
	AppUpdate_Link = _Update_Link;
	
	if(real(_Update_Minimal) > version_int)
		AppUpdate_Mandatory = true;
}