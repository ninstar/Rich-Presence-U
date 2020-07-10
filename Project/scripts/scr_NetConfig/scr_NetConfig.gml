/// @param local_override

ini_open(SaveDir+"NETWORK.cfg");

global.NET_URL_About = ini_read_string("URLS", "about", "hpps://");
global.NET_Update_Version = ini_read_real("UPDATE", "version", Version);
global.NET_Update_Mandatory = ini_read_real("UPDATE", "mandatory", 0);
global.NET_Update_Download = ini_read_string("UPDATE", "download", "hpps://");
global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "hpps://");
global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "hpps://");
global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "hpps://");
	
ini_close();

// Redirecionamento customizado
if(argument0)
&&(file_exists(program_directory+"\\NETWORK.cfg")){
	    
	ini_open(program_directory+"\\NETWORK.cfg");
	
	global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "hpps://");
	global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "hpps://");
	global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "hpps://");
	
	ini_close();
}