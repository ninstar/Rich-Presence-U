/// @description Network
if(ds_map_find_value(async_load, "id") == GUI_TitleIcon){
	
	if(ds_map_find_value(async_load, "status") >= 0){
	
		// Save icon in cache
		var _CacheIcon = DirSave+ "cache\\" + sGetPlatform(global.RPC_Platform) + "\\" + string_zeros(global.RPC_TitleSelected, 3)+".png";
		sprite_save(GUI_TitleIcon, 0, _CacheIcon);

		// Download finished
		GUI_LoadingIcon_Show = false;
		GUI_LoadingIcon_Anim = 0;		
	}
}