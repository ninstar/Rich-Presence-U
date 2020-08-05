/// @description Interace

// In-background
#region Presets

var _Text, _Scale;

// GUI
display_set_gui_size(window_get_width(), window_get_height());

var _X = 16;
var _Y = 16;
var _W = display_get_gui_width()-16;
var _H = display_get_gui_height()-16;

// Cursor
var _CursorX = device_mouse_x_to_gui(0);
var _CursorY = device_mouse_y_to_gui(0);

// Colors
Color_Background = merge_color($36312f, $f2f3f5, 1-GUI_Theme_Anim);
Color_Field = merge_color($252220, $ffffff, 1-GUI_Theme_Anim);
Color_Text = merge_color($36312f, $f2f3f5, GUI_Theme_Anim);
Color_Platform = merge_color(GUI_Color_Platform[GUI_Color_Begin], GUI_Color_Platform[GUI_Color_End], GUI_Color_Anim);

// Default font
draw_set_font(fSegoeUI);

#endregion
#region Functions

/// @func	_string_fit
var _string_fit = function(base_scale, max_width){

	var _T = 1;
	if(base_scale > max_width)
		_T =  max_width / base_scale;
	
	return _T;
}

/// @func	_draw_droplist
var _draw_droplist = function(x, y, wfield, slots, array){
	
	var _PreviousColor = draw_get_color();
	var _Hover = -1;

	// Fill
	draw_set_color(Color_Field);
	draw_roundrect_ext(x, y, wfield, y + ((19+2)*slots), 3, 3, false);

	// Items
	for(var _i = 0; _i < slots; ++_i){

		// Line
		draw_set_color(Color_Background);
		if(_i > 0)
			draw_line(x + 4, y + ((19+2)*_i), wfield - 4, y + ((19+2)*_i));
	
		// Hover
		if(point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x + 1, y + ((19+2)*_i), wfield - 2, (y-1) + ((19+2)*(_i+1)))){
	
			_Hover = _i;
			draw_set_color(Color_Platform);
			draw_roundrect_ext(x + 2, (y+2) + ((19+2)*_i), wfield - 2, (y-2) + ((19+2)*(_i+1)), 3, 3, false);
			draw_set_color($ffffff);
		}
		else
			draw_set_color(Color_Text);

		// Text string
		var _T = array_get(array, _i);
		if(array_get(array, _i) == "%CUSTOM%")
			_T = "["+global.DLG_FIELD_CustomTitle+"]";

		// Text scale
		var _S = 1;
		if((string_width(_T) * (14/32)) > (wfield-28))
			_S =  (wfield-28) / (string_width(_T) * (14/32));
		
		draw_text_transformed(x + 5, y+1 + ((19+2)*_i), _T, _S * (14/32), 14/32, 0);
	}
	
	// Selection
	if(_Hover > -1){

		// Wait 5 frames for next interaction
		GUI_Sleep = 5;
		
		// Change cursor pointer
		if(window_get_cursor() != cr_handpoint)
			window_set_cursor(cr_handpoint);

		// Choose
		if((mouse_check_button_pressed(mb_any))
		||(keyboard_check_pressed(vk_enter)))
			return _Hover;
	}
	else{
	
		// Normal pointer
		if(window_get_cursor() != cr_arrow)
			window_set_cursor(cr_arrow);
	}
	draw_set_color(_PreviousColor);
}

/// @func	_draw_input_field
var _draw_input_field = function(x, y, wfield, icon, title){

	var _PreviousColor = draw_get_color();
	var _DownScale14 = 14 / 32;
	
	// Icon and title
	draw_set_alpha(.75);
	draw_text_transformed(x, y, icon, _DownScale14, _DownScale14, 0);
	draw_text_transformed(x + 20, y -1, title, _DownScale14, _DownScale14, 0);
	draw_set_alpha(1);
	
	// Field
	draw_set_color(Color_Field);
	draw_roundrect_ext(x, y+19, wfield, y + (19+23), 3, 3, false);		
	draw_set_color(_PreviousColor);
}

// @func	_draw_selection_field
var _draw_selection_field = function(x, y, state, icon, title){

	var _DownScale14 = 14 / 32;
	var _DownScale16 = 16 / 32;

	// Icon
	draw_set_alpha(.75);
	draw_text_transformed(x, y, " "+icon, _DownScale16, _DownScale16, 0);
	draw_set_alpha(1);
	
	// Title
	draw_text_transformed(x + 42, y - 1, title, _DownScale14, _DownScale14, 0);
	
	// Check
	if(state){
		
		var _PreviousColor = draw_get_color();
		draw_set_color(Color_Platform);
		draw_text_transformed(x, y, "", _DownScale16, _DownScale16, 0);
		draw_set_color($ffffff);
		draw_text_transformed(x, y, "", _DownScale16, _DownScale16, 0);
		draw_set_color(_PreviousColor);
	}
}

#endregion

// User view
#region Layout

// Background
draw_sprite_stretched_ext(sBackground, 0, _X-24, _Y-24, _W+(24*2), _H+(24*2), Color_Background, 1);
draw_sprite_stretched_ext(sBackground, 0, _X-24, _Y-16, _W+(24*2), 48, Color_Platform, 1);

// Overlay
if(CURRENT_TitleString == "%CUSTOM%")
	_Text = global.DLG_FIELD_CustomTitle;
else
	_Text = global.DLG_FIELD_Details;

var _Update = "";
if(global.NET_Update_Version > Version)
	_Update = "";

// Platform
draw_sprite_ext(sPlatforms, 0, _W-110, _Y, 1, 1, 0, $000000, .10);
draw_sprite_ext(sPlatforms, 1+global.RPC_Platform, _W-110, _Y, 1, 1, 0, $ffffff, 1);

draw_set_color($ffffff);
draw_text_transformed(_X, _Y, "  "+_Update, (18/32), (18/32), 0);							// Toolbox
draw_set_color(Color_Text);
_draw_input_field(_X, _Y+36, _W, "", global.DLG_FIELD_Title);									// Title
_draw_input_field(_X, _Y+83, _W, "", _Text);													// Details
_draw_input_field(_X, _Y+130, _W, "", "ID / "+global.DLG_FIELD_FriendCode);					// Friend Code
_draw_selection_field(_X, _H-44, global.RPC_ElapsedTime, "", global.DLG_FIELD_ElapsedTime);	// Elapsed Time
_draw_selection_field(_X, _H-18, !RPC_IsON, "", global.DLG_FIELD_HideRPC);					// Hide RPC

// Title icon
if(GUI_LoadingIcon_Show){

	// Loading...
	draw_rectangle(_W-50, _Y+1, _W-1, _Y+50, false);
	draw_set_color(Color_Background);
	draw_text_transformed(_W-40, _Y+8, "", 1, 1, 0);
}
else{
	
	// Preview
	if(sprite_exists(GUI_TitleIcon)){
		
		// Box
		draw_set_color($000000);
		draw_set_alpha(.10);
		draw_rectangle(_W-51, _Y, _W, _Y+51, false);
		draw_set_alpha(1);
		
		// Bitmap
		draw_sprite_stretched_ext(GUI_TitleIcon, 0, _W-49, _Y+2, 48, 48, $ffffff, 1);
		for(var _L = -1; _L < 2; ++_L)
			draw_sprite_stretched_ext(GUI_TitleIcon, 0, (_W-49)+_L, (_Y+2)+_L, 48, 48, $ffffff, .05);
	}
}
draw_set_color(Color_Text);

// Apply RPC
draw_roundrect_ext(_W-46, _H-46, _W-1, _H-1, 3, 3, false);
draw_set_color(Color_Background);
draw_text_transformed(_W-38, _H-38, "", 1, 1, 0);
draw_set_color(Color_Text);

var _Network = "";
if(os_is_network_connected(false))
	_Network = "";

draw_set_alpha(GUI_ApplyRPC_Anim / (60*1));
draw_roundrect_ext(_W-46, _H-46, _W-1, _H-1, 3, 3, false);
draw_set_color(Color_Background);
draw_text_transformed(_W-39, _H-40, _Network, 1, 1, 0);
draw_set_color(Color_Text);
draw_set_alpha(1);

// Friend Code
draw_sprite_ext(sFriendCode, 0, _W - 19, _Y + 153, 1, 1, 0, $ffffff, 1);
draw_sprite_ext(sFriendCode, 1+global.RPC_Platform, _W - 19, _Y + 153, 1, 1, 0, $ffffff, 1);

_Text = global.DLG_TIP_Empty;

if(FIELD_Type == eField.FriendCode)
	_Text = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode) + GUI_TextBlink;	// Typing
else if(global.RPC_FriendCode != "")
	_Text = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode);					// Filled
else
	draw_set_alpha(.5);																		// Empty

// Text scale
_Scale = _string_fit(string_width(_Text) * (14/32), _W-44);
draw_text_transformed(_X+5, _Y+130 + (19+2), _Text, _Scale * (14/32), 14/32, 0);
draw_set_alpha(1);

#endregion
#region Drop Lists

// Details
draw_text_transformed(_W-20, _Y+83 + (19+5), "", (14/32), (14/32), 0);
_Text = global.DLG_TIP_Empty;

if(FIELD_Type == eField.Details)
	_Text = global.RPC_DetailsString + GUI_TextBlink;	// Typing
else if(global.RPC_DetailsString != "")
	_Text = global.RPC_DetailsString;					// Filled
else
	draw_set_alpha(.5);									// Empty

// Text scale
_Scale = _string_fit(string_width(_Text) * (14/32), _W-44);
draw_text_transformed(_X+5, _Y+83 + (19+2), _Text, _Scale * (14/32), 14/32, 0);
draw_set_alpha(1);

if(FIELD_DropList == eField.Details){

	// Drop list
	var _DropList_Index = _draw_droplist(_X, _Y+128, _W, clamp(ceil((_H-(_Y+128)) / (19+2)), 0, array_length(DROPLIST_Details)), DROPLIST_Details);
	if(_DropList_Index > -1)
		global.RPC_DetailsString = DROPLIST_Details[_DropList_Index]+" ";
}

// Title
if(FIELD_Type == eField.Title)
&&(FIELD_DropList == eField.Title)
&&(!GUI_About_Show){
		
	var _Select = -1;
		
	// Typing title
	_Text = keyboard_string + GUI_TextBlink;
	if(keyboard_string == ""){
		
		draw_set_alpha(.5);
		draw_text_transformed(_X+12, _Y+36 + 3 + (19+2), "", _Scale * (14/32), 14/32, 0);
		draw_text_transformed(_X+8 + 22, _Y+36 + (19+2), global.DLG_TIP_Search, _Scale * (14/32), 14/32, 0);
		draw_set_alpha(1);
	}
	
	// Text scale
	_Scale = _string_fit(string_width(_Text) * (14/32), _W-22);
	draw_text_transformed(_X+5, _Y+36 + (19+2), _Text, _Scale * (14/32), 14/32, 0);
	draw_set_alpha(1);
	
	// Searching for titles
	_QUEUE_Title[0] = "";
	_QUEUE_TitleID[0] = 0;
	_QUEUE_Total = 0;
	for(var _L = 0; _L < PLATFORM_TotalTitles; ++_L){
	
		// Search for titles that have any of the characters typed so far
		if(string_pos(string_lower(keyboard_string), string_lower(PLATFORM_Title[_L])) > 0){
			
			_QUEUE_Title[_QUEUE_Total] = PLATFORM_Title[_L];
			_QUEUE_TitleID[_QUEUE_Total] = _L;
			_QUEUE_Total++;
		}
	}

	// Drop list
	if(_QUEUE_Total > 0){
	
		var _DropList_Index = _draw_droplist(_X, _Y+81, _W, clamp(ceil((_H-(_Y+128)) / (19+2)), 0, _QUEUE_Total), _QUEUE_Title);
		if(_DropList_Index > -1)
			_Select = _DropList_Index;
			
		// [ENTER] Select first
		if(keyboard_check_pressed(vk_enter))
			_Select = 0;
	}
	
	// Select
	if(_Select > -1){

		// Save previous title details
		var _Platform = string_upper( scr_GetPlatform(global.RPC_Platform) );
		ini_open(DirSave+"USER.ini")
		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", global.RPC_DetailsMode);
		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", global.RPC_DetailsOnline);
		ini_write_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", global.RPC_DetailsString);
		
		// Select new title
		global.RPC_TitleSelected = _QUEUE_TitleID[_Select];
		CURRENT_TitleString = _QUEUE_Title[_Select];

		// Load details of the new title
		global.RPC_DetailsMode = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", eDetails.Custom);
		global.RPC_DetailsOnline = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", false);
		global.RPC_DetailsString = ini_read_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", "");
		ini_close();
	
		// Select client ID according to new title index
		PREVIOUS_ClientID = CURRENT_ClientID;
		CURRENT_ClientID = PLATFORM_ClientID[floor(global.RPC_TitleSelected / 149)];

		// Remove previous title icon
		if(sprite_exists(GUI_TitleIcon))
			sprite_delete(GUI_TitleIcon);
	
		// Check if there is already an icon for the new title in the cache
		var _CacheIcon = DirSave+ "cache\\" + scr_GetPlatform(global.RPC_Platform) + "\\" + string_add_zeros(global.RPC_TitleSelected, 3)+".png";
		if(file_exists(_CacheIcon))
			GUI_TitleIcon = sprite_add(_CacheIcon, 1, false, true, 0, 0);
		else{
	
			// Download icon for new title
			GUI_LoadingIcon_Show = true;
			GUI_TitleIcon = sprite_add(global.NET_Redirect[global.RPC_Platform] + "/" + string_add_zeros(global.RPC_TitleSelected, 3)+".png", 1, false, true, 0, 0);
		}
		
		// Generate new timestamp
		RPC_Timestamp_GetNew = true;
			
		// Stop typing
		FIELD_Type = eField.NONE;
	}
}
else{

	// Title [Display]
	_Text = CURRENT_TitleString;
	if(CURRENT_TitleString == "%CUSTOM%")
		_Text = "["+global.DLG_FIELD_CustomTitle+"]";

	// Text scale
	_Scale = _string_fit(string_width(_Text) * (14/32), _W-28);
	draw_text_transformed(_X+5, _Y+36 + (19+2), _Text, _Scale * (14/32), 14/32, 0);
}

#endregion
#region Windows

if(GUI_About_Anim > 0)
||(GUI_Platforms_Anim > 0){

	// About
	if(GUI_About_Anim > 0){
		
		// Foreground
		draw_sprite_stretched_ext(sBackground, 0, _X-24, _Y-24, _W+(24*2), _H+(24*2), Color_Background, GUI_About_Anim);
		
		// Display
		draw_text_transformed(_X  - ( 32 * (1-GUI_About_Anim) ), _Y, "", (18/32), (18/32), 0);
		draw_sprite_ext(sLogo, 0, ((_W+16)/2), 52 - (96 * (1-GUI_About_Anim)), 1, 1, 0, Color_Text, 1);
		draw_sprite_ext(sCredits, 0, ((_W+16)/2), ( ((_H+16)/2) + 22 ) + (_H * (1-GUI_About_Anim)), 1, 1, 0, Color_Text, 1);
		draw_sprite_ext(sLinks, 0, _X - ( 128 * (1-GUI_About_Anim) ), _H, 1, 1, 0, Color_Text, 1);
		draw_set_halign(fa_right);
		draw_text_transformed(_W + ( 64 * (1-GUI_About_Anim) ), _H - 14, VersionString, (14/32), (14/32), 0);
		draw_set_halign(fa_left);
		
		// Options
		var _Hover = false;
		var _Press = mouse_check_button_released(mb_any);
			
		// Close
		if(point_in_circle(_CursorX, _CursorY, _X+9, _Y+9, 9)){
			
			if(_Press)
				GUI_About_Show = false;
			_Hover = true;
		}
		
		// Link
		if(point_in_rectangle(_CursorX, _CursorY, _X, _H-29, _X+29, _H)){
			
			if(_Press)
				url_open(global.NET_URL_About);
			_Hover = true;
		}
		
		// Repository
		if(point_in_rectangle(_CursorX, _CursorY, _X + 36, _H-29, _X+29 + 36, _H)){
	
			if(_Press)
				url_open("https://github.com/MarioSilvaGH/Rich-Presence-U");
			_Hover = true;
		}
	
		// Change cursor pointer
		if(_Hover){

			// Option
			if(window_get_cursor() != cr_handpoint)
				window_set_cursor(cr_handpoint);
		}
		else{
	
			// Normal
			if(window_get_cursor() != cr_arrow)
				window_set_cursor(cr_arrow);
		}
		
		// [ESCAPE] Close
		if(keyboard_check_released(vk_escape))
			GUI_About_Show = false;
	}
	
	// Platform
	if(GUI_Platforms_Anim > 0){
	
		// Foreground
		draw_sprite_stretched_ext(sBackground, 0, _X-24, _Y-24, _W+(24*2), _H+(24*2), Color_Platform, GUI_Platforms_Anim);
		
		// Display
		draw_sprite_ext(sPlatformsOption, 0, ((_W+16)/2) - (64+8), ((_H+16)/2) + (_H * (1-GUI_Platforms_Anim)), 1, 1, 0, $ffffff, 1);			// Wii U
		draw_sprite_ext(sPlatformsOption, 1, ((_W+16)/2), ((_H+16)/2) + ((_H+200) * (1-GUI_Platforms_Anim)), 1, 1, 0, $ffffff, 1);				// Nintendo Switch
		draw_sprite_ext(sPlatformsOption, 2, ((_W+16)/2) + (64+8), ((_H+16)/2) + ((_H+400) * (1-GUI_Platforms_Anim)), 1, 1, 0, $ffffff, 1);		// Nintendo 3DS
	
		// Options
		var _Hover = -1;
		var _Press = mouse_check_button_released(mb_any);

		// Platforms
		if(point_in_rectangle(_CursorX, _CursorY, ((_W+16)/2) - ((64+8)+32), ((_H+16)/2) - 32, ((_W+16)/2) - ((64+8)-32), ((_H+16)/2) + 32))	_Hover = 0; // Wii U
		if(point_in_rectangle(_CursorX, _CursorY, ((_W+16)/2) - 32, ((_H+16)/2) - 32, ((_W+16)/2) + 32, ((_H+16)/2) + 32))	_Hover = 1;						// Nintendo Switch
		if(point_in_rectangle(_CursorX, _CursorY, ((_W+16)/2) + ((64+8)-32), ((_H+16)/2) - 32, ((_W+16)/2) + ((64+8)+32), ((_H+16)/2) + 32))	_Hover = 2; // Nintendo 3DS
		
		// Select
		if(_Hover > -1)
		&&(_Press){
			
			// New platform
			if(_Hover != global.RPC_Platform){
				
				// Color transition
				GUI_Color_Anim = 0;
				GUI_Color_Begin = global.RPC_Platform;
			
				// Save platform changes
				scr_UserConfig(true, false);
		
				// New platform
				global.RPC_Platform = _Hover;
				GUI_Color_End = _Hover;
		
				// Load new platform changes
				scr_UserConfig(false, false);
				event_user(0);
			}
	
			// Close
			GUI_Platforms_Show = false;
		}
		
		// Change cursor pointer
		if(_Hover != -1){

			// Option
			if(window_get_cursor() != cr_handpoint)
				window_set_cursor(cr_handpoint);
		}
		else{
	
			// Normal
			if(window_get_cursor() != cr_arrow)
				window_set_cursor(cr_arrow);
		}
		
		// [ESCAPE] Close
		if(keyboard_check_released(vk_escape))
			GUI_Platforms_Show = false;
	}
}

#endregion