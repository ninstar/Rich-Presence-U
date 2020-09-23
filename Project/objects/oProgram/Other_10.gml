/// @description Load platform
#region List

ini_open(DirSave + sGetPlatform(global.RPC_Platform)+".ini");

// Clean arrays
PLATFORM_ClientID = "";
PLATFORM_Title = "";

// Up to 10 clients, 149 titles each
PLATFORM_TotalTitles = 0;
var _Offset = 0;
for(var _c = 0; _c < 9+1; _c++){

	// Clients
	PLATFORM_ClientID[_c] = ini_read_string("CLIENT_"+string(_c), "ID", "");

	// Titles
	for(var _t = _Offset; _t < _Offset + (148+1); _t++){
	
		// Stop loop if there is no title in the current slot
		if(ini_read_string("CLIENT_"+string(_c), "T_"+string_zeros(_t,3), "") == "")
			break;
		else{
		
			// Add title to the list
			PLATFORM_Title[_t] = ini_read_string("CLIENT_"+string(_c), "T_"+string_zeros(_t,3), "");
			PLATFORM_TotalTitles++;
		}
	}
	
	// Search for other 149 titles
	_Offset = _t;
}

ini_close();

#endregion

// Close in case of failure
if(PLATFORM_TotalTitles <= 0){
	
	show_message(global.OutputMessage[? "Error_Client"]);
	game_end();
	exit;
}

// Select a previously saved title (prevent it from exceeding the total)
CURRENT_TitleString = PLATFORM_Title[clamp(global.RPC_TitleSelected, 0, PLATFORM_TotalTitles-1)];

// Select client ID according to new title index
PREVIOUS_ClientID = CURRENT_ClientID;
CURRENT_ClientID = PLATFORM_ClientID[floor(global.RPC_TitleSelected / 149)];

// Remove previous title icon
if(sprite_exists(GUI_TitleIcon))
	sprite_delete(GUI_TitleIcon);
	
// Check if there is already an icon for the new title in the cache
var _CacheIcon = DirSave+ "cache\\" + sGetPlatform(global.RPC_Platform) + "\\" + string_zeros(global.RPC_TitleSelected, 3)+".png";
if(file_exists(_CacheIcon))
	GUI_TitleIcon = sprite_add(_CacheIcon, 1, false, true, 0, 0);
else{
	
	// Download icon for new title
	GUI_LoadingIcon_Show = true;
	GUI_TitleIcon = sprite_add(global.NET_Redirect[global.RPC_Platform] + "/" + string_zeros(global.RPC_TitleSelected, 3)+".png", 1, false, true, 0, 0);
}

// Generate new timestamp
RPC_Timestamp_GetNew = true;