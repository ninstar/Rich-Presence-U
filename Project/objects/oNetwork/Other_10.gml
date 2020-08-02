/// @description Update plataforms

// Start program
if(DOWNLOAD_Platform > 2)
	event_user(1);
else
	DOWNLOAD_File = http_get_file(global.NET_Redirect[DOWNLOAD_Platform]+"/client.ini", SaveDir + scr_GetPlatform(DOWNLOAD_Platform)+".ini");