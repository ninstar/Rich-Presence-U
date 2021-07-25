/// @description Update status
if(State_Connected){
	
	if(!Setting.DisplayStatus)
		np_clearpresence();
	else{
		
		// Get new timestamp
		if(!State_Playing)
		||(Client_RunningID != Client_CurrentID)
		||(!Setting.PreserveTime && (Client_StatusConsole != Platform.Console || Client_StatusName != Title.Name))
			Details.Timestamp = date_current_datetime();

		Client_StatusConsole = Platform.Console;
		Client_StatusName = Title.Name;
	
		// Elapsed time
		np_setpresence_timestamps(Details.Timestamp * Details.ElapsedTime, 0, false);
	
		// About link
		if(Details.About == true){
	
			var _Domain = "";
			var _Domain = "";
			var _Query = "";
			if(Title.Name == "")
			||(Title.CustomName != ""){
			
				_Query = "https://www.google.com/search?q="+dURLEncond(Title.CustomName);
				_Domain =  Lang[? "ABOUT_INTERNET"];
			}
			else{

				switch(Title.Region){
		
					case(eREGION.JP):
			
						// nintendo.co.jp
						var _Shard = "";
						switch(Platform.Console){
		
							case(ePLATFORM.WiiU):			_Shard = "wiiu";	break;
							case(ePLATFORM.NintendoSwitch):	_Shard = "switch";	break;
							case(ePLATFORM.Nintendo3DS):	_Shard = "3ds";		break;
						}
				
						_Query = "https://www.nintendo.co.jp/search/?q="+dURLEncond(Title.Name)+"&shard="+_Shard+"/";
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.co.jp";
	
					break;
					case(eREGION.EU):
			
						// nintendo.co.uk
						_Query = "https://www.nintendo.co.uk/Search/Search-299117.html?q="+dURLEncond(Title.Name);
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.co.uk";
				
					break;
					default:
				
						// nintendo.com
						_Query = "https://www.nintendo.com/search/#category=all&page=1&query="+dURLEncond(Title.Name);
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.com";
				
					break;
				}
			}
			np_setpresence_buttons(0, _Domain, _Query);
			show_debug_message(_Query);
		}
		else
			np_setpresence_buttons(0, "", "");

		// Friend code
		var _Tooltip = "";
		var _Tooltip_Icon = "";
		var _Description = Title.Description;
		if(Details.FriendCode != ""){
	
			if(Title.Description == ""){
			
				_Description = dFormatFC(Platform.Console, Details.FriendCode);
				if(Platform.Console == ePLATFORM.WiiU)
					_Description = "NNID: "+_Description;
			}
			else{
			
				_Tooltip_Icon = "_tooltip";
				_Tooltip = dFormatFC(Platform.Console, Details.FriendCode);
				if(Platform.Console == ePLATFORM.WiiU)
					_Tooltip = "NNID: "+_Tooltip;
			}
		}

		// Custom name
		var _Title = Title.Name;
		if(Title.CustomName != "")
			_Title = Title.CustomName;
	
		// Icon
		var _Icon = Title.Icon;
		if(_Icon == "")
			_Icon = "_default";
	
		// State
		if(_Title != "")
			_Title = _Title+" ";
		if(_Description != "")
			_Description = _Description+" ";
		if(_Tooltip != "")
			_Tooltip = _Tooltip+" ";

		np_setpresence_more(_Tooltip, "Rich Presence U "+version_stg, false);	
		np_setpresence(_Description, _Title, _Icon, _Tooltip_Icon);
	
		State_Playing = true;
		Client_RunningID = Client_CurrentID;
	}
	
	alarm[0] = 5;
}