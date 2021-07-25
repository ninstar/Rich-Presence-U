/// @description Download files
if(async_load[? "id"] == Download){

    // If download is finished (0) or failed (-1)...
    if(async_load[? "status"] < 1){

		// Database
		if(array_length(Download_List) > 0){

			// Next download
			if(Download_Index < array_length(Download_List)-1){
			
				Download_Index++;
				var _DL = Download_List[Download_Index];
				Download = http_get_file(_DL[0], _DL[1]);
			}
			else{
			
				Client_CurrentID = dClientID(Platform.Console, Title.Client);
				
				// Initializate RPC
				if(Download_BlockApp){
					
					np_initdiscord(Client_CurrentID, true, np_steam_app_id_empty);
					Client_RunningID = Client_CurrentID;
				}
				
				Download_BlockApp = false;
				Download_Index = -1;
			}
		}
		else
			event_user(1);
	}
}