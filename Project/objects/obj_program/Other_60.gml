/// @description Carregar icone (Network)
if(ds_map_find_value(async_load, "id") == GUI_TitleIcon){
	
	if(ds_map_find_value(async_load, "status") >= 0){
	
		// Download finalizado
		GUI_LoadingIcon_Show = false;
		GUI_LoadingIcon_Anim = 0;
	}
}