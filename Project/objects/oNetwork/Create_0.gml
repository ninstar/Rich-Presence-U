/// @description Checar rede

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
window_set_position(_WinX, _WinY);
window_set_size(_WinW, _WinH);
ini_close();
scr_UserConfig(false, true);

// Network settings
var _Repo = "https://github.com/MarioSilvaGH/Rich-Presence-U/raw/master/";

// Close if it is disconnected from the internet...
if!(os_is_network_connected(true)){
	
	show_message(global.DLG_Connection);
	game_end();
}
else{

	DOWNLOAD_File = noone;
	DOWNLOAD_Platform = -1;
	
	// Load previously downloaded metadata
	scr_NetConfig(true);

	// Download latest metadata (after application has been closed for 15 minutes or more)
	if(date_current_datetime() >= date_inc_minute(_CheckTime, 15))
		DOWNLOAD_File = http_get_file(_Repo+"NETWORK.cfg", DirSave+"NETWORK.cfg");
	else
		event_user(1);
}