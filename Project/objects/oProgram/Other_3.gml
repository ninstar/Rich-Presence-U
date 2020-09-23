/// @description Shutdown

// RPC
FreeDiscord();

// Save user settings
ini_open(DirSave+"USER.ini");
ini_write_real("RPC_GLOBAL", "PlatformID", global.RPC_Platform);
ini_write_real("RPC_GLOBAL", "Theme", global.GUI_Theme);
ini_write_real("RPC_GLOBAL", "Time", date_current_datetime());
ini_write_real("RPC_GLOBAL", "WinX", window_get_x());
ini_write_real("RPC_GLOBAL", "WinY", window_get_y());
ini_write_real("RPC_GLOBAL", "WinW", window_get_width());
ini_write_real("RPC_GLOBAL", "WinH", window_get_height());
ini_close();
sUserConfig(true, true);

// Unload translations
if(ds_exists(global.OutputMessage, ds_type_map))
	ds_map_destroy(global.OutputMessage);