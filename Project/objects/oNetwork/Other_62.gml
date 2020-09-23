/// @description Download files
if(ds_map_find_value(async_load,"id") == DOWNLOAD_File){

    // If download is finished (0) or failed (-1)...
    if(ds_map_find_value(async_load,"status") < 1){

		// Load new metadatas
		if(DOWNLOAD_Platform == -1)
			sNetConfig(true);
		
        // Start downloading next platform...
		DOWNLOAD_Platform++;
		event_user(0);
    }
}