/// @description Check network

// Interface
GUI_Alpha = 1;
GUI_Boot_Anim = 0;

// Window
window_set_min_width(256);
window_set_min_height(256);

// Load user settings
ini_open(DirSave+"USER.ini");
global.RPC_Platform = ini_read_real("RPC_GLOBAL", "PlatformID", ePlatform.WiiU);
global.GUI_Theme = ini_read_real("RPC_GLOBAL","Theme", 0);
var _CheckTime = ini_read_real("RPC_GLOBAL","Time", 0);
var _WinX = ini_read_real("RPC_GLOBAL","WinX", window_get_x());
var _WinY = ini_read_real("RPC_GLOBAL","WinY", window_get_y());
var _WinW = ini_read_real("RPC_GLOBAL","WinW", 256);
var _WinH = ini_read_real("RPC_GLOBAL","WinH", 256);

ini_close();
sUserConfig(false, true);

// Network settings
var _Checkup = 1;

// Close if it is disconnected from the internet...
if!(os_is_network_connected(true)){
	
	_Checkup = 0;
	show_message(global.OutputMessage[? "Error_Connection"]);
	game_end();
}

// Close if components are missing...
if(global.Repository == "")
||(!file_exists(DirApp+"discord-rpc.dll"))
||(!file_exists(DirApp+"wrapper.dll")){

	_Checkup = 0;
	show_message(global.OutputMessage[? "Error_Application"]);
	game_end();
}

if(_Checkup){

	DOWNLOAD_File = noone;
	DOWNLOAD_Platform = -1;
	
	// Load previously downloaded metadata
	sNetConfig(true);

	// 15 minutes or more after application has been closed...
	if(date_current_datetime() >= date_inc_minute(_CheckTime, 15)){
	
		// Reset window settings
		window_set_position((display_get_width()-256)/2, (display_get_height()-256)/2);
		window_set_size(256, 256);
		
		// Download latest metadata
		DOWNLOAD_File = http_get_file(global.Repository+"/raw/master/NETWORK.cfg", DirSave+"NETWORK.cfg");
		
		// Clean previous cache
		directory_destroy(DirSave+"cache");
	}
	else{
		
		// Restore window settings
		window_set_position(_WinX, _WinY);
		window_set_size(_WinW, _WinH);
		
		// Start program
		event_user(1);
	}
}