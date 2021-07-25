/// @description Cycle

// Standby
var _Draw = true;
if(window_has_focus())
	Standby = 600;
else{
	
	Standby -= Standby > 0;
	_Draw = Standby;
}
draw_enable_drawevent(_Draw);
	
// Program
if(Standby > 0){

	var _SYSTEM_Pause = os_is_paused();
	
	// Mouse
	var _MOUSE_Hold = mouse_check_button(mb_left) || mouse_check_button(mb_right);
	var _MOUSE_Press = mouse_check_button_pressed(mb_left) mouse_check_button_pressed(mb_right);
	var _MOUSE_Release = mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right);

	// Cursor
	if(display_mouse_get_x() > window_get_x())
	&&(display_mouse_get_y() > window_get_y())
	&&(display_mouse_get_x() < window_get_x() + window_get_width())
	&&(display_mouse_get_y() < window_get_y() + window_get_height()){
		
		Cursor_X = mouse_x;
		Cursor_Y = mouse_y;
	}
	else{

		Cursor_X = -16;
		Cursor_Y = -16;
	}
	
	// Interface
	#region Hover

	Hover = eBUTTON.None;
	Tooltip_Display = false;

	var _I;

	// Window
	if(os_type == os_windows){
		
		for(_I = eBUTTON.Close; _I < eBUTTON.Suspend+1; ++_I){
	
			if(point_in_rectangle(Cursor_X, Cursor_Y, Button[_I].X, 0, Button[_I].X+56, 46)){
		
				Hover = _I;
				break;
			}
		}
	}

	// Main
	if(Type != eTYPE.TitleSearch)
	&&(!Download_BlockApp){
	
		// Shorcuts
		for(_I = eBUTTON.Restart; _I < eBUTTON.Settings+1; ++_I){
	
			if(point_in_rectangle(Cursor_X, Cursor_Y, Button[_I].X, 56, Button[_I].X+48, 104)){
		
				if(_I != eBUTTON.Restart){
					
					Tooltip_X = Button[_I].X - 16;
					Tooltip_Y = 80;
					Tooltip_Content = Button[_I].Tip;
					Tooltip_Horizontal = true;
					Tooltip_Display = true;
				}

				Hover = _I;
				break;
			}
		}
		
		if(Hover == eBUTTON.Update && !AppUpdate)
		||(Hover == eBUTTON.Restart && State_Name != Lang[? "ERROR"]){
			
			Hover = eBUTTON.None;
			Tooltip_Display = false;
		}
		
		// Change page
		if(Page_Current != Page){
	
			Page_Current = Page;
			switch(Page_Current){

				case(ePAGE.Settings):	Page_S = eBUTTON.Status;		Page_E = eBUTTON.Refresh;			break;
				case(ePAGE.Platform):	Page_S = eBUTTON.Console;		Page_E = eBUTTON.Region;			break;
				case(ePAGE.Details):	Page_S = eBUTTON.FriendCode;	Page_E = eBUTTON.ElapsedTime;		break;
				case(ePAGE.Title):		Page_S = eBUTTON.TitleSearch;	Page_E = eBUTTON.Description;		break;
			}
		}

		// Page tabs
		if(Page != ePAGE.Settings){
	
			for(_I = eBUTTON.Platform; _I < eBUTTON.Title+1; ++_I){
	
				if(point_in_rectangle(Cursor_X, Cursor_Y, Button[_I].X, 160, Button[_I].X+140, 208)){

					Tooltip_X = Button[_I].X + 70;
					Tooltip_Y = 144;
					Tooltip_Content = Button[_I].Tip;
					Tooltip_Horizontal = false;
					Tooltip_Display = true;
		
					Hover = _I;
					break;
				}
			}
		}

		// Page
		if(!Context_Display)
		&&(Type != eTYPE.Console)
		&&(Type != eTYPE.Region)
		&&(Type != eTYPE.TitleSearch){
		
			// Current page
			for(_I = Page_S; _I < Page_E+1; ++_I){
	
				if(point_in_rectangle(Cursor_X, Cursor_Y, 32, Button[_I].Y, 480, Button[_I].Y+48)){
		
					Hover = _I;
					break;
				}
			}

			// Apply
			if(point_in_rectangle(Cursor_X, Cursor_Y, 32, 432, 480, 480)){
			
				if(Page_Animation[ePAGE.Title] == 1)
				&&(Search_Animation == 0)
				&&(!Setting.DisplayStatus
				|| !State_Connected
				|| !os_is_network_connected(false)){

					Tooltip_X = 256;
					Tooltip_Y = 416;
					
					if(!State_Connected)
					||(!os_is_network_connected(false))
						Tooltip_Content = Lang[? "UPDATE_DISCONNECT"];
					else
						Tooltip_Content = Lang[? "UPDATE_INVISIBLE"];
						
					Tooltip_Horizontal = false;
					Tooltip_Display = true;
				}
				
				
				Hover = eBUTTON.Apply;
			}
		}
	}

	#endregion
	#region Interactions

	// Context menu
	if(Context_Display){

		Context_Hover = -1;
		for(var _I = 0; _I < array_length(Context_Items); ++_I){
		
			if(point_in_rectangle(Cursor_X, Cursor_Y, Context_X+24, Context_Y+24 + (64*_I), Context_X+256, Context_Y+24 + (64 * (_I+1)))){
				
				Context_Hover = _I;
				break;
			}
		}
		
		if(_MOUSE_Release){
		
			switch(Context_Hover){
			
				case(0): clipboard_set_text(keyboard_string);	keyboard_string = "";			break;	// Cut
				case(1): clipboard_set_text(keyboard_string);									break;	// Copy
				case(2): keyboard_string = string_replace_all(clipboard_get_text(), "\n", " ");	break;	// Paste
			}
			Context_Hover = -1;
			Context_Display = false;
		}
	}
	
	// Typing
	switch(Type){

		case(eTYPE.Console):
	
			DropList_Hover = -1;
			for(var _I = 0; _I < platform_total; ++_I) {
		
				var _Y = Button[eBUTTON.Console].Y + ( 52 * (_I+1) );
				if(point_in_rectangle(Cursor_X, Cursor_Y, 32, _Y, 480, _Y+52)){
				
					DropList_Hover = _I;
					break;
				}
			}
		
			if(_MOUSE_Release)
			||(_SYSTEM_Pause){
		
				// Save
				dUserData(true, false, true, true);
			
				if(DropList_Hover != -1)
					Platform.Console = DropList_Hover;
			
				Client_CurrentID = dClientID(Platform.Console, Title.Client);
			
				// Load
				dUserData(false, false, true, true);
			
				DropList_Hover = -1;
				Type = eTYPE.None;
			}
	
		break;
		case(eTYPE.Region):	

			DropList_Hover = -1;
			for(var _I = 0; _I < 3; ++_I) {
		
				var _Y = Button[eBUTTON.Console].Y + ( 52 * (_I+1) );
				if(point_in_rectangle(Cursor_X, Cursor_Y, 32, _Y, 480, _Y+52)){
				
					DropList_Hover = _I;
					break;
				}
			}

			if(_MOUSE_Release)
			||(_SYSTEM_Pause){
		
				if(DropList_Hover != -1)
					Platform.Region = DropList_Hover;
				
				DropList_Hover = -1;
				Type = eTYPE.None;
			}
		
		break;
		case(eTYPE.CustomName):		Title.CustomName = keyboard_string;		break;
		case(eTYPE.Description):	Title.Description = keyboard_string;	break;
		case(eTYPE.FriendCode):
		
			if(Platform.Console == ePLATFORM.WiiU)
				keyboard_string = string_copy(keyboard_string, 1, 16);
			else
				keyboard_string = string_digits( string_copy(keyboard_string, 1, 12) );
		
			Details.FriendCode = keyboard_string;
		
			if(string_length(Details.FriendCode) > 0)
				Texts_FriendCode = dFormatFC(Platform.Console, Details.FriendCode);
			else
				Texts_FriendCode = "";

			if(keyboard_check_released(vk_enter))
			||(keyboard_check_pressed(vk_escape))
			||(_MOUSE_Release)
			||(_SYSTEM_Pause){
		
				if(Platform.Console == ePLATFORM.WiiU && string_length(Details.FriendCode) < 6)
				||(Platform.Console != ePLATFORM.WiiU && string_length(Details.FriendCode) < 12){
			
					Details.FriendCode = "";
					Texts_FriendCode = "";
				}
			
				Type = eTYPE.None;
			}
	
		break;
		case(eTYPE.TitleSearch):

			Search_Title = keyboard_string;
			Search_Hover = -1;
			
			// Find		
			Search_Cooldown -= Search_Cooldown > 0;
		
			if(keyboard_check_released(vk_anykey))
				Search_Cooldown = 12;
		
			if(Search_Cooldown == 0){

				Search_List_Icon = [];
				Search_List_Client = [];
				Search_List_Name = [];
				Search_List_Region = [];
			
				if(Search_Title != "")
				&&(ds_exists(Spreadsheet, ds_type_grid)){
	
					var _Priority = [];
					switch(Platform.Region){
			
					    case(eREGION.JP):	_Priority = [eREGION.JP, eREGION.US, eREGION.EU];	break;
						case(eREGION.EU):	_Priority = [eREGION.EU, eREGION.US, eREGION.JP];	break;
						default:			_Priority = [eREGION.US, eREGION.EU, eREGION.JP];	break;
					}
	
					var _Found = 0;
					var _Sufix = ["_us", "_eu", "_jp"];
					for(var _D = 1; _D < ds_grid_height(Spreadsheet); ++_D){
					
						var _Index = Spreadsheet[# 0, _D];
				
						var _Name_0 = Spreadsheet[# 4+_Priority[0], _D];
						var _Name_1 = Spreadsheet[# 4+_Priority[1], _D];
						var _Name_2 = Spreadsheet[# 4+_Priority[2], _D];
	
						var _Client_0 = Spreadsheet[# 1+_Priority[0], _D];
						var _Client_1 = Spreadsheet[# 1+_Priority[1], _D];
						var _Client_2 = Spreadsheet[# 1+_Priority[2], _D];
				
						if(string_pos(string_lower(Search_Title), string_lower(_Name_0)) > 0)
						||(string_pos(string_lower(Search_Title), string_lower(_Name_1)) > 0)
						||(string_pos(string_lower(Search_Title), string_lower(_Name_2)) > 0){
					
							Search_List_Icon[_Found] = _Index;
					
							Search_List_Name[_Found] = "";
							if(_Name_2 != ""){	Search_List_Name[_Found] = _Name_2;	Search_List_Region[_Found] = _Priority[2];	}	// Lower priority
							if(_Name_1 != ""){	Search_List_Name[_Found] = _Name_1;	Search_List_Region[_Found] = _Priority[1];	}
							if(_Name_0 != ""){	Search_List_Name[_Found] = _Name_0;	Search_List_Region[_Found] = _Priority[0];	}	// Higher priority

							Search_List_Client[_Found] = "";
							if(_Client_2 != ""){	Search_List_Client[_Found] = _Client_2;	if(_Index != "") Search_List_Icon[_Found] = _Index+_Sufix[_Priority[2]]; else Search_List_Icon[_Found] = "_default"; }
							if(_Client_1 != ""){	Search_List_Client[_Found] = _Client_1;	if(_Index != "") Search_List_Icon[_Found] = _Index+_Sufix[_Priority[1]]; else Search_List_Icon[_Found] = "_default"; }
							if(_Client_0 != ""){	Search_List_Client[_Found] = _Client_0;	if(_Index != "") Search_List_Icon[_Found] = _Index+_Sufix[_Priority[0]]; else Search_List_Icon[_Found] = "_default"; }
	
							_Found++;
						}

						if(_Found > 5)
							break;
					}
				}
				else{
			
					// History
					for(var _H = 0; _H < array_length(History); ++_H){
	
						if(History[_H].Icon != "")
						&&(History[_H].Icon != "_default"){
					
							Search_List_Icon[_H] = History[_H].Icon;
							Search_List_Client[_H] = History[_H].Client;
							Search_List_Name[_H] = History[_H].Name;
							Search_List_Region[_H] = History[_H].Region;
						}
					}
				}
				
				Search_Cooldown = -1;
			}
		
			// Hover
			for(var _O = 0; _O < array_length(Search_List_Icon); ++_O){
			
				var _Y = 180 + ( 52 * _O );
				if(point_in_rectangle(Cursor_X, Cursor_Y, 32, _Y, 480, _Y+52))
					Search_Hover = _O;
			}
		
			// Select
			var _Select = -1;
			if(point_in_rectangle(Cursor_X, Cursor_Y, 32, 432, 480, 480))
			&&(array_length(Search_List_Icon) <= 4)
				Search_Hover = -2;
			
			if(_MOUSE_Release)
			&&(Search_Hover == -2){
				
				// No title
				Title.Icon = "_default";
				Title.Client = "0";
				Title.Name = "";
				Title.Region = 0;
				
				_Select = -2;
			}
			else{
						
				if(array_length(Search_List_Icon) > 0){
					
					if(_MOUSE_Release)
					&&(Search_Hover != -1)
						_Select = Search_Hover;
					else if(keyboard_check_released(vk_enter))
						_Select = 0;
				}

				if(_Select != -1){
			
					// Save
					dUserData(true, false, false, true);
			
					Title.Icon = Search_List_Icon[_Select];
					Title.Client = Search_List_Client[_Select];
					Title.Name = Search_List_Name[_Select];
					Title.Region = Search_List_Region[_Select];
			
					Search_Title = Title.Name;

					// Load
					dUserData(false, false, false, true);
			
					// Check if it is already in the history
					var _InHistory = false;
					for(var _H = 0; _H < array_length(History); ++_H){
				
						if(History[_H].Name == Title.Name){
						
							_InHistory = true;
							break;
						}
					}
				
					if(!_InHistory){
								
						// Resort
						for(var _H = array_length(History)-1; _H > 0; --_H){
				
							if(History[_H-1].Name != Title.Name){
					
								History[_H].Icon = History[_H-1].Icon;
								History[_H].Client = History[_H-1].Client;
								History[_H].Name = History[_H-1].Name;
								History[_H].Region = History[_H-1].Region;
							}
						}		

						// Top item
						History[0].Icon = Title.Icon;
						History[0].Client = Title.Client;
						History[0].Name = Title.Name;
						History[0].Region = Title.Region;
					}
				}
			}
			if(_Select != -1){

				Search_Title = Title.Name;
				
				Client_CurrentID = dClientID(Platform.Console, Title.Client);
				
				if(ds_exists(Spreadsheet, ds_type_grid))
					ds_grid_destroy(Spreadsheet);
				
				Type = eTYPE.None;
			}
			
		break;

	}

	if(Type != eTYPE.None){
	
		if(keyboard_check_released(vk_enter))
		||(keyboard_check_pressed(vk_escape))
		||(_MOUSE_Release)
		||(_SYSTEM_Pause){
		
			Type = eTYPE.None;
	
			if(ds_exists(Spreadsheet, ds_type_grid))
				ds_grid_destroy(Spreadsheet);
		}
	
		// Clipboard
		if(keyboard_check(vk_control)){

			// Cut
			if(keyboard_check_pressed(ord("X"))){
			
				clipboard_set_text(keyboard_string);
				keyboard_string = "";
			}

			// Copy
			if(keyboard_check_pressed(ord("C")))
				clipboard_set_text(keyboard_string);
		
			// Paste
			if(keyboard_check_pressed(ord("V")))
				keyboard_string = string_replace_all(clipboard_get_text(), "\n", " ");
		}
	
		// Delete text
		if(keyboard_check_released(vk_delete))
			keyboard_string = "";
	
		// Hint
		if(alarm[1] == -1){
		
			Texts_Hint = "|";
			alarm[1] = 30;
		}
	}
	else{

		if(alarm[1] > -1)
			alarm[1] = -1;
	}
	
	// Button
	if(_MOUSE_Release){

		if(os_type == os_windows){
			
			switch(Hover){
	
				case(eBUTTON.Close):	game_end();		break;
				case(eBUTTON.Expand):	Setting.WindowSize = (Setting.WindowSize+1) % 3;	break;
				case(eBUTTON.Suspend):	window_command_run(window_command_minimize);		break;
			}
		}
		if(!Download_BlockApp){
			
			switch(Hover){
		
				case(eBUTTON.Platform):	Page = ePAGE.Platform;	Type = eTYPE.None;	break;
				case(eBUTTON.Details):	Page = ePAGE.Details;	Type = eTYPE.None;	break;
				case(eBUTTON.Title):	Page = ePAGE.Title;		Type = eTYPE.None;	break;
				case(eBUTTON.Refresh):	if(Download_Index == -1)	event_user(1);	break;

				case(eBUTTON.Console):		Type = eTYPE.Console;	break;
				case(eBUTTON.Region):		Type = eTYPE.Region;	break;

				case(eBUTTON.PreserveTime):	Setting.PreserveTime = !Setting.PreserveTime;	break;
				case(eBUTTON.About):		Details.About = !Details.About;					break;
				case(eBUTTON.ElapsedTime):	Details.ElapsedTime = !Details.ElapsedTime;		break;
		
				case(eBUTTON.FriendCode):	keyboard_string = Details.FriendCode;	Type = eTYPE.FriendCode;	break;
				case(eBUTTON.TitleSearch):	
		
					keyboard_string = "";
					Type = eTYPE.TitleSearch;
					Search_Cooldown = 0;
					Spreadsheet = dTitlesSheet(Platform.Console);
		
				break;
				case(eBUTTON.CustomName):	keyboard_string = Title.CustomName;	Type = eTYPE.CustomName;		break;
				case(eBUTTON.Description):	keyboard_string = Title.Description;	Type = eTYPE.Description;	break;
		
				case(eBUTTON.Restart):	game_restart();	break;
				case(eBUTTON.Update):	if(string_pos("://", AppUpdate_Link) > 0) url_open(AppUpdate_Link);		break;
				case(eBUTTON.Settings):
		
					if(Page != ePAGE.Settings){
			
						Page_Reminder = Page;
						Page = ePAGE.Settings;
					}
					else
						Page = Page_Reminder;
				
					Type = eTYPE.None;
			
				break;
				case(eBUTTON.Status):		
		
					Setting.DisplayStatus = !Setting.DisplayStatus;
				
					if(State_Playing)
						event_user(0);
		
				break		
				case(eBUTTON.Apply):
		
					switch(Page){
					
						case(ePAGE.Settings):	if(string_pos("://", Link_Page) > 0) url_open(Link_Page);	break;
						case(ePAGE.Platform):	Page = ePAGE.Details;	break;
						case(ePAGE.Details):	Page = ePAGE.Title;		break;
						case(ePAGE.Title):

							if(State_Connected)
							&&(os_is_network_connected(false)){
					
								if(Client_RunningID != Client_CurrentID){
								
									np_clearpresence();
								
									// Forgive me for committing this sin
									__np_shutdown();
								
									np_initdiscord(Client_CurrentID, true, np_steam_app_id_empty);
								}
						
								event_user(0);
							}
							
						break;
					}
			
					Type = eTYPE.None;
			
				break;
			}
		}
	}

	// Open context menu
	if(mouse_check_button_released(mb_right))
	&&(!Context_Display)
	&&( Type == eTYPE.FriendCode
	 || Type == eTYPE.CustomName
	 || Type == eTYPE.Description ){
		
		Context_Display = true;
	
		if(Cursor_X < 256)
			Context_X = clamp(Cursor_X, 0, 512 - 280);
		else
			Context_X = clamp(Cursor_X-280, 0, 512 - 280);
		
		Context_Y = clamp(Cursor_Y, 0, 512 - ( (80 * array_length(Context_Items) - 16 ) ));
	}
	
	#endregion

	// Others
	#region Move window

	if(os_type == os_windows){
		
		var _TargetWH = 256 + (128 * Setting.WindowSize);
		if(WindowWH != _TargetWH){
		
			WindowWH = lerp(WindowWH, _TargetWH, .25);
			window_set_size(round(WindowWH), round(WindowWH));
		}	
	
		if(point_in_rectangle(Cursor_X, Cursor_Y, 0, 0, 512, 46))
		&&(_MOUSE_Press)
		&&(Hover == eBUTTON.None){

			Window_Move = true;
			Window_PivotX = display_mouse_get_x() - window_get_x();
			Window_PivotY = display_mouse_get_y() - window_get_y();
		}

		if(Window_Move){

			Setting.WindowX = display_mouse_get_x()-Window_PivotX;
			Setting.WindowY = display_mouse_get_y()-Window_PivotY;
		
			window_set_position(Setting.WindowX, Setting.WindowY);
		
			if(_MOUSE_Hold == false)
				Window_Move = false;
		}
	}
	
	#endregion
	#region Animations

	// Interpolation
	Tooltip_Animation = lerp(Tooltip_Animation, Tooltip_Display, .25);
	Boot_Animation = lerp(Boot_Animation, Download_BlockApp, .15);
	Refresh_Animation = lerp(Refresh_Animation, Download_Index > -1, .15);
	Search_Animation = lerp(Search_Animation, Type == eTYPE.TitleSearch, .25);
	Search_Animation_Button = lerp(Search_Animation_Button, array_length(Search_List_Icon) <= 4, .25);
	
	// No-interpolation
	Button[eBUTTON.Status].Anim += ( Setting.DisplayStatus - Button[eBUTTON.Status].Anim ) / 5;
	Button[eBUTTON.PreserveTime].Anim += ( Setting.PreserveTime - Button[eBUTTON.PreserveTime].Anim ) / 5;
	Button[eBUTTON.About].Anim += ( Details.About - Button[eBUTTON.About].Anim ) / 5;
	Button[eBUTTON.ElapsedTime].Anim += ( Details.ElapsedTime - Button[eBUTTON.ElapsedTime].Anim ) / 5;

	// Page
	for(var _A = 0; _A < ePAGE.Settings+1; ++_A)
		Page_Animation[_A] = lerp(Page_Animation[_A], Page == _A, .2);
	
	// Refresh
	if(Boot_Animation > 0)
	||(Refresh_Animation > 0){
		 
		var _Speed = 8;
		if(Download_BlockApp)
			_Speed = 4;
		
		Refresh_Spinning = (Refresh_Spinning+_Speed) % 360;
	}
	
	// Cursor
	if( Hover != eBUTTON.None )
	||( Context_Display && Context_Hover > -1 )
	||( Type == eTYPE.TitleSearch && Search_Hover != -1 )
	||( (Type == eTYPE.Console || Type == eTYPE.Region)  && DropList_Hover > -1 )
		window_set_cursor(cr_handpoint);
	else
		window_set_cursor(cr_default);

	#endregion

	// Update RPC
	if(alarm[0] == -1)
		alarm[0] = 1;
	
	#region Window buffer
	
	if(!surface_exists(WindowBuffer))
		WindowBuffer = surface_create(512, 512);
	
	surface_set_target(WindowBuffer);
	draw_clear_alpha(c_black, 0);
	
	gpu_set_tex_filter(true);
	
	draw_set_font(gFontUI);
	
	// Background
	draw_sprite(gLYT_Body, 0, 0, 0);
	
	if(os_type == os_windows){
		
		draw_sprite(gBTN_Close, Hover == eBUTTON.Close, Button[eBUTTON.Close].X, 0);
		draw_sprite(gBTN_Expand, Hover == eBUTTON.Expand, Button[eBUTTON.Expand].X, 0);
		draw_sprite(gBTN_Suspend, Hover == eBUTTON.Suspend, Button[eBUTTON.Suspend].X, 0);
	}
	
	// User
	if(sprite_exists(State_Avatar))
		draw_sprite_stretched(State_Avatar, 0, 16, 56, 50, 50);
	else
		draw_sprite(gLYT_Avatar, 0, 16, 56);
	
	draw_sprite(gLYT_Avatar, 1, 16, 56);

	var _Network = os_is_network_connected(false);
	var _State = State_Status;
	
	if(!State_Connected)
	||(!_Network){
		
		draw_sprite(gLYT_Avatar, 2 + (Hover == eBUTTON.Restart), 16, 56);
		
		if(!_Network)
			_State = Lang[? "NETWORK_DOWN"];
	}
	else{
	
		if(State_Playing)
			_State = _State+" - "+Lang[? "PLAYING"];

		if(!Setting.DisplayStatus)
			_State = _State+" ("+Lang[? "INVISIBLE"]+")";
	}
	
	draw_text_transformed(78, 56, State_Name, .75, .75, 0);
	draw_set_colour($bdbab8);
	draw_text_transformed(78, 82, _State, .625, .625, 0);
	draw_set_colour(c_white);

	// Title
	if(Page_Animation[ePAGE.Title] > 0){

		var _A = -512 * (1-Page_Animation[ePAGE.Title]);
	
		if(Search_Animation <= 0)
			dBTN_Input(Type == eTYPE.TitleSearch, true, _A+32, Button[eBUTTON.TitleSearch].Y, Title.Name, Lang[? "SEARCH_TITLE"]);

		dBTN_Input(Type == eTYPE.CustomName, false, _A+32, Button[eBUTTON.CustomName].Y, Title.CustomName, Lang[? "CUSTOM_NAME"]);
		dBTN_Input(Type == eTYPE.Description, false, _A+32, Button[eBUTTON.Description].Y, Title.Description, Lang[? "DESCRIPTION"]);
		dBTN_Reponsive(false, 4, _A+32, 432, Lang[? "UPDATE_STATUS"]);
	}

	// Details
	if(Page_Animation[ePAGE.Details] > 0){

		var _A = -512 * (1-Page_Animation[ePAGE.Details]);
	
		draw_sprite_part(gLYT_Body, 0, 0, 221, 512, 291, _A, 221);
	
		var _FC = Lang[? "FRIEND_CODE"];
		if(Platform.Console == ePLATFORM.WiiU)
			_FC = Lang[? "NINTENDO_ID"];
	
		dBTN_Input(Type == eTYPE.FriendCode, false, _A+32, Button[eBUTTON.FriendCode].Y, Texts_FriendCode, _FC);
		dBTN_Switch(Button[eBUTTON.About].Anim, _A+32, Button[eBUTTON.About].Y, Lang[? "ABOUT"], Lang[? "ABOUT_TIP"]);
		dBTN_Switch(Button[eBUTTON.ElapsedTime].Anim, _A+32, Button[eBUTTON.ElapsedTime].Y, Lang[? "ELAPSED_TIME"], "");
		dBTN_Reponsive(false, 0, _A+32, 432, Lang[? "NEXT"]);
	}

	// Platform
	if(Page_Animation[ePAGE.Platform] > 0){

		var _A = -512 * (1-Page_Animation[ePAGE.Platform]);

		draw_sprite_part(gLYT_Body, 0, 0, 221, 512, 291, _A, 221);
	
		dBTN_Reponsive(false, 0, _A+32, 432, Lang[? "NEXT"]);
	
		if(Type != eTYPE.None){
		
			var _Tooltip = Lang[? "CONSOLE"];
			var _List = Texts_Console;
			var _Name = Texts_Console[Platform.Console];
			if(Type == eTYPE.Region){
			
				_Tooltip = Lang[? "REGION"];
				_List = Texts_Region;
				_Name = Texts_Region[Platform.Region];
			}
		
			dBTN_Tooltip(_A+32, 231, _Tooltip);
			dBTN_DropList(_A+32, Button[eBUTTON.Console].Y, _List, DropList_Hover);
			dBTN_Drop(false, _A+32, Button[eBUTTON.Console].Y, _Name);
		}
		else{
	
			dBTN_Tooltip(_A+32, 231, Lang[? "CONSOLE"]);
			dBTN_Drop(false, _A+32, Button[eBUTTON.Console].Y, Texts_Console[Platform.Console]);
	
			dBTN_Tooltip(_A+32, 327, Lang[? "REGION"]);
			dBTN_Drop(false, _A+32, Button[eBUTTON.Region].Y, Texts_Region[Platform.Region]);
		}
	}

	// Settings
	var _Displace = 0;
	if(Page_Animation[ePAGE.Settings] > 0){
	
		var _OverDisplace = 512 * (1-Page_Animation[ePAGE.Settings]);

		dBTN_Switch(Button[eBUTTON.Status].Anim, _OverDisplace+32, Button[eBUTTON.Status].Y, Lang[? "STATUS"], Lang[? "STATUS_TIP"]);
		dBTN_Switch(Button[eBUTTON.PreserveTime].Anim, _OverDisplace+32, Button[eBUTTON.PreserveTime].Y, Lang[? "PRESERVE"], Lang[? "PRESERVE_TIP"]);
		dBTN_Reponsive(false, 0, _OverDisplace+32, Button[eBUTTON.Refresh].Y, Lang[? "REFRESH"]);
		dBTN_Tooltip(_OverDisplace+32, 376, Lang[? "REFRESH_TIP"]);
		dBTN_Reponsive(false, 2, _OverDisplace+32, 432, Lang[? "PAGE"]);
	
		if(Download_Index > 0){
		
			draw_set_alpha(Refresh_Animation);
			dBTN_Reponsive(false, 0, _OverDisplace+32, Button[eBUTTON.Refresh].Y, "");
			draw_set_alpha(1);
			draw_sprite_ext(gLYT_Icon, 2, _OverDisplace+256, Button[eBUTTON.Refresh].Y+24, 1, 1, -Refresh_Spinning, $FFFFFF, Refresh_Animation);
		}
	
		// Version
		draw_sprite_ext(gLYT_Body, 1, 0, 0, 1, 1, 0, $FFFFFF, Page_Animation[ePAGE.Settings]);
		draw_set_alpha(Page_Animation[ePAGE.Settings]);
		dBTN_Tooltip(32, 60, Lang[? "VERSION"]+": "+version_stg);
		dBTN_Tooltip(32, 83, Lang[? "DEVELOPED"]+" NinStar");
		draw_set_alpha(1);
	
		_Displace = -512 * Page_Animation[ePAGE.Settings];
	}

	// Pages
	var _Icons = 2 * Platform.Console;
	draw_sprite(sBTN_Platform, _Icons + (Page == ePAGE.Platform || Hover == eBUTTON.Platform), _Displace+Button[eBUTTON.Platform].X, 160);
	draw_sprite(sBTN_Details, _Icons + (Page == ePAGE.Details || Hover == eBUTTON.Details), _Displace+Button[eBUTTON.Details].X, 160);
	draw_sprite(gBTN_Title, _Icons + (Page == ePAGE.Title || Hover == eBUTTON.Title), _Displace+Button[eBUTTON.Title].X, 160);

	// Shorcuts
	draw_sprite(gBTN_Settings, Page == ePAGE.Settings || Hover == eBUTTON.Settings, Button[eBUTTON.Settings].X, 56);
	if(AppUpdate)
		draw_sprite(gBTN_Update, Hover == eBUTTON.Update, Button[eBUTTON.Update].X, 56);

	// Search bar
	if(Search_Animation > 0){

		var _A = 1-Search_Animation;

		draw_sprite_part_ext(gLYT_Body, 0, 0, 128, 512, 384, 0, 44 + ( 84 * _A ), 1, 1, $FFFFFF, Search_Animation);
		draw_sprite_part_ext(gLYT_Body, 0, 0, 221, 512, 291, 0, 221, 1, 1, $FFFFFF, Search_Animation);
	
		dBTN_Input(Type == eTYPE.TitleSearch, true, 32, 77 + ( (Button[eBUTTON.TitleSearch].Y-77) * _A ), Search_Title, Lang[? "SEARCH_TITLE"]);
	
		draw_set_alpha(Search_Animation);
	
		// Tooltip
		var _Tip = Lang[? "RECENT"];
		if(Search_Title != "")
			_Tip = Lang[? "RESULTS"];
		dBTN_Tooltip(32, 148 + (96*_A), string_upper(_Tip));
	
		// 404
		if(array_length(Search_List_Name) == 0){
	
			draw_set_colour($bdbab8);
			draw_set_halign(fa_middle);
			draw_text_transformed(256, 270, Lang[? "NO_RESULTS"], .75, .75, 0);
			draw_set_halign(fa_left);
			draw_set_colour($FFFFFF);
		}
	
		// Hover
		if(Search_Hover > -1)
			draw_sprite(gBTN_Responsive, 0, 32, 180 + (52*Search_Hover));
	
		// List
		draw_set_font(gFontGlyphs);
		for(var _T = 0; _T < array_length(Search_List_Name); ++_T){
	
			var _Fit = 1;
			var _W = string_width(Search_List_Name[_T]); //*.75; //.875;
			if(_W > 424)
				_Fit = 424 / _W;
		
			draw_text_transformed(44, 192 + ( (52*_T) - 3 ), Search_List_Name[_T], 1 * _Fit, 1, 0);
		}
		draw_set_font(gFontUI);
	
		draw_set_alpha(1);
	
		if(Search_Animation_Button > 0){
	
			var _B = 1 - (Search_Animation_Button * Search_Animation);
			dBTN_Reponsive(false, 0, 32, 432 + (96*_B), Lang[? "DEFAULT_TITLE"]);
		}
	}

	// Tooltip
	if(Tooltip_Animation > 0){

		var _W = clamp(string_width(Tooltip_Content) * .875, 128, 512);

		var _tX = clamp(Tooltip_X - (_W * .5), 64, 512 - (_W + 64));
		var _tY = clamp(Tooltip_Y, 32, 512) -48;
		if(Tooltip_Horizontal){
	
			_tX = ( Tooltip_X - (_W * .5) ) - ( (_W * .5) + 32);
			_tY = clamp(Tooltip_Y, 32, 512) - 16;
		}
	
		draw_set_alpha(Tooltip_Animation);
	
		draw_sprite(gLYT_TooltipArrow, Tooltip_Horizontal, Tooltip_X, Tooltip_Y);
		draw_sprite_stretched(gLYT_Tooltip, 0, _tX-32, _tY-16, _W+64, 64);
		draw_set_halign(fa_middle);
		draw_text_transformed(_tX + (_W * .5), _tY, Tooltip_Content, .875, .875, 0);
		draw_set_halign(fa_left);
	
		draw_set_alpha(1);
	}
		
	// Context menu
	if(Context_Display){
	
		var _L = array_length(Context_Items);
		draw_sprite_stretched(gLYT_Context, 0, Context_X, Context_Y, 280, (80 * _L) - 16);
	
		if(Context_Hover > -1)
			draw_sprite_stretched(gLYT_Context, 1, Context_X, Context_Y + (64 * Context_Hover), 280, 96);
		
		for(var _I = 0; _I < _L; ++_I)
			draw_text_transformed(Context_X+32, Context_Y + 32 + (64*_I), Context_Items[_I], .875, .875, 0);
	}
	
	// Boot
	if(Boot_Animation > 0){

		var _A = 1-Boot_Animation;

		draw_sprite_part_ext(gLYT_Body, 0, 0, 128, 512, 384, 0, 44 + ( 84 * _A ), 1, 1, $FFFFFF, Boot_Animation);
		draw_sprite_part_ext(gLYT_Body, 0, 0, 221, 512, 291, 0, 221, 1, 1, $FFFFFF, Boot_Animation);
		
		draw_sprite_ext(gLYT_Loading, 0, 256, 300, 1, 1, 0, $FFFFFF, Boot_Animation);
		draw_sprite_ext(gLYT_Loading, 1, 256, 300, 1, 1, -Refresh_Spinning, $FFFFFF, Boot_Animation);
	}

	surface_reset_target();
	
	#endregion
}