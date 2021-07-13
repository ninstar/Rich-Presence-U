/// @description Update status
if(State_Connected){

	// Elapsed time
	var _Timestamp = 0;
	if(Details.ElapsedTime == true){

		if(Client_UpdateTimestamp){
			
			Details.Timestamp = date_current_datetime();
			Client_UpdateTimestamp = false;
		}
		
		_Timestamp = Details.Timestamp;
	}
		
	if(!Setting.DisplayStatus)
		np_clearpresence();
	else{
		
		// Elapsed time
		np_setpresence_timestamps(_Timestamp, 0, false);

		// About link
		if(Details.About == true){
	
			var _Domain = Lang[? "ABOUT_INTERNET"];
			var _Query = string_replace_all(Title.Name, " ", "%20");
			if(Title.Name == "")
			||(Title.CustomName != ""){
			
				_Query = "https://www.google.com/search?q="+string_replace_all(Title.CustomName, " ", "%20");
				_Domain = "internet";
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
				
						_Query = "https://www.nintendo.co.jp/search/?q="+string_replace_all(Title.Name, " ", "%20")+"&shard="+_Shard;
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.co.jp";
						show_debug_message(_Query);
				
					break;
					case(eREGION.EU):
			
						// nintendo.co.uk
						_Query = "https://www.nintendo.co.uk/Search/Search-299117.html?q="+_Query;
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.co.uk";
				
					break;
					default:
				
						// nintendo.com
						_Query = "https://www.nintendo.com/search/#query="+_Query;
						_Domain = Lang[? "ABOUT_TITLE"]+" nintendo.com";
				
					break;
				}
			}
			np_setpresence_buttons(0, _Domain, _Query);
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
		if(Title.Icon == "")
			_Icon = "_default";
	
		// State
		np_setpresence_more(_Tooltip, "Rich Presence U "+version_stg, false);	
		np_setpresence(_Description, _Title, _Icon, _Tooltip_Icon);
	}
	
	alarm[0] = 5;
	State_Playing = true;
}