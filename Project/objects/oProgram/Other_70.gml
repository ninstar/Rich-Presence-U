/// @description Async
switch(async_load[? "event_type"]){

	case("DiscordReady"):
			
		// Get profile information
		if(State_GotProfileData == false){
			
			State_Avatar = sprite_add(np_get_avatar_url(async_load[? "user_id"], async_load[? "avatar"]), 1, false, true, 0, 0);
			State_Name = async_load[? "username"];
			State_GotProfileData = true;
		}
		
		State_Status = Lang[? "CONNECTED"];
		State_Connected = true;
		
	break;
	case("DiscordDisconnected"):
	
		State_Status = Lang[? "DISCONNECTED"];
		State_Connected = false;
		
	break;
	case("DiscordError"):
	
		// Get profile information
		State_Name = Lang[? "ERROR"];
		State_Status = Lang[? "RESTART_APP"];
		State_Connected = false;
		
	break;
}