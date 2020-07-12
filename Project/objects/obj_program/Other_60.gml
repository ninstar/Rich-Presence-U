/// @description Carregar icone (Network)
if(ds_map_find_value(async_load, "id") == GUI_TitleIcon){
	
	if(ds_map_find_value(async_load, "status") >= 0){
	
		// Salvar icone em cache
		var _CacheIcon = SaveDir+ "cache\\" + scr_GetPlatform(global.RPC_Platform) + "\\" + string_add_zeros(global.RPC_TitleSelected, 3)+".png";
		sprite_save(GUI_TitleIcon, 0, _CacheIcon);

		// Download finalizado
		GUI_LoadingIcon_Show = false;
		GUI_LoadingIcon_Anim = 0;		
	}
}