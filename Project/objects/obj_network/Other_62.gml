/// @description Baixar arquivo...
if(ds_map_find_value(async_load,"id") == DOWNLOAD_File){

    // Se download finalizar (0) ou falhar (-1)...
    if(ds_map_find_value(async_load,"status") < 1){

		// Carregar metadados atualizados
		if(DOWNLOAD_Platform == -1)
			scr_NetConfig(true);
		
        // Baixar próxima plataforma...
		DOWNLOAD_Platform++;
		event_user(0);
    }
}