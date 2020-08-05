/// @description Initialization

// Preset details
DROPLIST_Details[0] = "";
ini_open(DirApp+"DETAILS.cfg");
for(var _P = 0; _P < 9; ++_P){

	var _P_Entry = ini_read_string("DETAILS", string(_P+1), "");
	if(_P_Entry != "")
		DROPLIST_Details[_P] = _P_Entry;
	else
		break;
}
ini_close();

// Display and animations
GUI_Theme_Anim = global.GUI_Theme;
GUI_About_Show = false;
GUI_About_Anim = 0;
GUI_Platforms_Show = false;
GUI_Platforms_Anim = 0;
GUI_ApplyRPC_Anim = 0;
GUI_TextBlink = "|";
alarm[0] = 15;

// System
GUI_TitleIcon = sprite_duplicate(sBackground);
GUI_LoadingIcon_Show = false;
GUI_Sleep = 0;
GPU_Sleep = false;

// Header color
GUI_Color_Anim = 1;
GUI_Color_Begin = global.RPC_Platform;
GUI_Color_End = global.RPC_Platform;
GUI_Color_Platform[ePlatform.WiiU] = $BE9100;
GUI_Color_Platform[ePlatform.NintendoSwitch] = $321BF4;
GUI_Color_Platform[ePlatform.Nintendo3DS] = $1A0F58;

// Fields
FIELD_Type = eField.NONE;
FIELD_DropList = eField.NONE;

// Status
RPC_IsON = true;
RPC_Down = false;
RPC_Timestamp_Stored = 0;
RPC_Timestamp_GetNew = true;

// Platform
CURRENT_ClientID = "";
event_user(0);