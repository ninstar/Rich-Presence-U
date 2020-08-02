/// @description System & I/O

// Automated
#region Display

// GPU sleep
if(!GPU_Sleep){
	
	// OFF
	if(!window_has_focus()){
		
		draw_enable_drawevent(GPU_Sleep);
		GPU_Sleep = true;
	}
}
else{

	// ON
	if(window_has_focus()){
		
		draw_enable_drawevent(GPU_Sleep);
		GPU_Sleep = false;
	}
	else
		exit;
}

// GUI scale
var _X = 16;
var _Y = 16;
var _W = display_get_gui_width()-16;
var _H = display_get_gui_height()-16;

// Cursor
var _CursorX = device_mouse_x_to_gui(0);
var _CursorY = device_mouse_y_to_gui(0);

// Sleep interval
GUI_Sleep -= (GUI_Sleep > 0);

#endregion
#region Animations

// Theme
GUI_Theme_Anim += ( global.GUI_Theme-GUI_Theme_Anim ) / 12;

// Header color
GUI_Color_Anim += ( 1-GUI_Color_Anim ) / 12;

// RPC applied
GUI_ApplyRPC_Anim -= (GUI_ApplyRPC_Anim > 0);

// About
if(GUI_About_Show)
	GUI_About_Anim += ( 1-GUI_About_Anim ) / 6;
else
	GUI_About_Anim -= .1 * (GUI_About_Anim > 0);

// Platform
if(GUI_Platforms_Show)
	GUI_Platforms_Anim += ( 1-GUI_Platforms_Anim ) / 6;
else
	GUI_Platforms_Anim -= .05 * (GUI_Platforms_Anim > 0);

#endregion

// Interactive
#region Options

// Exception
if(GUI_About_Anim > 0)
||(GUI_Platforms_Anim > 0)
	exit;

// Find option
var _Hover = eOption.NONE;

// About
if(point_in_circle(_CursorX, _CursorY, _X+9, _Y+9, 9))
	_Hover = eOption.About;

// Theme
if(point_in_circle(_CursorX, _CursorY, _X+33, _Y+9, 9))
	_Hover = eOption.Theme;

// Update
if(point_in_circle(_CursorX, _CursorY, _X+52, _Y+9, 9))
&&(global.NET_Update_Version > Version)
	_Hover = eOption.Update;
	
// Platform
if(point_in_rectangle(_CursorX, _CursorY, _W-111, _Y, _W - (111-53), _Y + 21))
	_Hover = eOption.Platform;

// Title
if(point_in_rectangle(_CursorX, _CursorY, _X+1, _Y+36 + (19+1), _W-2, _Y+36 + (19+24-2)))
	_Hover = eOption.Title;

// Details
if(point_in_rectangle(_CursorX, _CursorY, _X+1, _Y+83 + (19+1), _W-2, _Y+83 + (19+24-2)))
	_Hover = eOption.Details;

// Friend Code
if(point_in_rectangle(_CursorX, _CursorY, _X+1, _Y+130 + (19+1), _W-2, _Y+130 + (19+24-2)))
	_Hover = eOption.FriendCode;

// Elapsed Time
if(point_in_rectangle(_CursorX, _CursorY, _X, _H - (27+18), _X+16, _H-27))
	_Hover = eOption.ElapsedTime;

if(GUI_ApplyRPC_Anim == 0){
	
	// Hide RPC
	if(point_in_rectangle(_CursorX, _CursorY, _X, _H - 18, _X+16, _H))
		_Hover = eOption.HideRPC;

	// Apply RPC
	if(point_in_rectangle(_CursorX, _CursorY, _W-46, _H-46, _W-1, _H-1))
	&&(FIELD_Type != eField.Title)
	&&(GUI_ApplyRPC_Anim == 0)
		_Hover = eOption.ApplyRPC;
}

// Change cursor pointer
if(FIELD_DropList == eOption.NONE){
	
	if(_Hover != eOption.NONE){

		// Option
		if(window_get_cursor() != cr_handpoint)
			window_set_cursor(cr_handpoint);
	}
	else{
	
		// Normal
		if(window_get_cursor() != cr_arrow)
			window_set_cursor(cr_arrow);
	}
}

// Mouse input
var _Press = mouse_check_button_released(mb_any);

// Force...
if(_Press){
		
	// Stop typing
	if(FIELD_Type != eField.NONE)
		FIELD_Type = eField.NONE;
	
	// Close drop list
	if(FIELD_DropList != eOption.NONE){
		
		FIELD_DropList = eOption.NONE;
		
		// Wait 5 frames for next interaction
		GUI_Sleep = 5;
	}
}

// Excecute option
if(GUI_Sleep == 0){
	
	// Pointer
	if(FIELD_Type != eField.Title)
	&&(_Press){

		switch(_Hover){
	
			case(eOption.About):		GUI_About_Show = true;								break;	// About
			case(eOption.Theme):		global.GUI_Theme = !global.GUI_Theme;				break;	// Theme
			case(eOption.Update):		url_open(global.NET_Update_Download);				break;	// Update
			case(eOption.Platform):		GUI_Platforms_Show = true;							break;	// Update
			case(eOption.ElapsedTime):	global.RPC_ElapsedTime = !global.RPC_ElapsedTime;	break;	// Elapsed Time
		
			// Title
			case(eOption.Title):

				// Start typing title
				FIELD_Type = eField.Title;
				FIELD_DropList = eField.Title;
		
				// Clear text
				keyboard_string = "";
				window_set_cursor(cr_arrow);
		
			break;
		
			// Details
			case(eOption.Details):

				if(_CursorX > _W-24)
					FIELD_DropList = eField.Details;		// Open drop list
				else
					FIELD_Type = eField.Details;			// Start typing details
			
				// Use the previous text as a sample
				keyboard_string = global.RPC_DetailsString;
		
			break;
		
			// Friend Code
			case(eOption.FriendCode):
	
				// Start typing details
				FIELD_Type = eField.FriendCode;
		
				// Use the previous text as a sample
				keyboard_string = global.RPC_FriendCode;
	
			break;
		
			// Hide RPC
			case(eOption.HideRPC):

				// Switch
				RPC_IsON = !RPC_IsON;
		
				// Turn off when needed
				if(!RPC_Down){
			
					FreeDiscord();
					RPC_Down = true;
				}
		
			break;
	
			// Apply RPC
			case(eOption.ApplyRPC):

				// 2 seconds animation
				GUI_ApplyRPC_Anim = 60*2;
		
				// Wait 1 second for next interaction
				GUI_Sleep = 60*1;
				
				// Display status
				RPC_IsON = true;
		
				// Update status
				if(RPC_IsON)
					event_user(1);
	
			break;
		}
	}

	// Shortcuts
	
	// [ENTER] Apply RPC
	if(keyboard_check_released(vk_enter))
	&&(GUI_ApplyRPC_Anim == 0){
	
		// 2 seconds animation
		GUI_ApplyRPC_Anim = 60*2;
		
		// Wait 1 second for next interaction
		GUI_Sleep = 60*1;
		
		// Display status
		RPC_IsON = true;
		
		// Update status
		if(RPC_IsON)
			event_user(1);
	}
}

#endregion
#region Fields

if(GUI_Sleep == 0){

	// Clear text
	if(keyboard_check_pressed(vk_delete))
		keyboard_string = "";
	
	// Clipboard
	if(keyboard_check(vk_control)){

		if(keyboard_check_pressed(ord("V")))
			keyboard_string = clipboard_get_text();		// Copy
		else if(keyboard_check_pressed(ord("C")))
			clipboard_set_text(keyboard_string);		// Paste
	}

	// Type...
	if(FIELD_Type == eField.Details){
	
		// Details
		keyboard_string = string_copy(keyboard_string, 0, 64);
	
		global.RPC_DetailsString = keyboard_string;
	}
	else if(FIELD_Type == eField.FriendCode){
	
		// Friend Code
		if(global.RPC_Platform ==  ePlatform.WiiU)
			keyboard_string = string_copy(keyboard_string, 0, 16);
		else
			keyboard_string = string_copy(string_digits(keyboard_string), 0, 12);

		global.RPC_FriendCode = keyboard_string;
	}
}

#endregion