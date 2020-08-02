/// @description Update status
#region Check RPC

if(RPC_IsON){

	// Shutdown case client ID has been changed
	if(CURRENT_ClientID != PREVIOUS_ClientID){

		if(!RPC_Down){
			
			FreeDiscord();
			RPC_Down = true;
		}
		
		PREVIOUS_ClientID = CURRENT_ClientID;
	}

	// Turns it back on if client ID is valid
	if(CURRENT_ClientID != "")
	&&(CURRENT_ClientID != "0"){

		if(RPC_Down){
			
			InitDiscord(CURRENT_ClientID);
			RPC_Down = false;
		}
	}
	else{

		show_message_async(global.DLG_ClientError);
		exit;
	}
}
else
	exit;
	
#endregion

// Use details as a custom title
if(PLATFORM_Title[global.RPC_TitleSelected] == "%CUSTOM%"){

	setDetails(global.RPC_DetailsString);
	setState("");
}
else{
	
	setDetails(PLATFORM_Title[global.RPC_TitleSelected]);
	setState(global.RPC_DetailsString);
}

// Title icon and version
setLargeImageKey(string_add_zeros(global.RPC_TitleSelected, 3));
setLargeImageText("Rich Presence U - "+VersionString);

// Service icon and friend code
var _FC_Icon = "";
var _FC = "";
if(global.RPC_FriendCode != ""){
	
	_FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode);
	_FC_Icon = "fc";
}
setSmallImageKey(_FC_Icon);
setSmallImageText(_FC);

// Generate new timestamp if necessary
if(RPC_Timestamp_GetNew){
	
	RPC_Timestamp_Stored = Now();
	RPC_Timestamp_GetNew = false;
}

// Elapsed time
setStartTimestamp(RPC_Timestamp_Stored * global.RPC_ElapsedTime);

// Submit Changes
UpdatePresence();