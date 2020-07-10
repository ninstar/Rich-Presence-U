/// @description Definições
#region Carregar

// Detalhes predefinidos
ini_open(program_directory+"\\PRESET.cfg");
PRESET_Details_1P = ini_read_string("RPC_DETAILS", "1P", "Single Player");
PRESET_Details_2P = ini_read_string("RPC_DETAILS", "2P", "Multiplayer");
PRESET_Details_ON = ini_read_string("RPC_DETAILS", "ON", " (Online)");
ini_close();

// Definições
ini_open(SaveDir+"USER.ini");
global.RPC_Platform = ini_read_real("RPC_GLOBAL", "PlatformID", ePlatform.WiiU);
ini_close();
scr_UserConfig(false, true);

#endregion
#region Interface

// Exibição e animações
GUI_TitleIcon = sprite_duplicate(spr_titleicon);
GUI_About_Show = false;
GUI_About_Anim = 0;
GUI_Platforms_Show = false;
GUI_Platforms_Anim = 0;
GUI_LoadingIcon_Show = false;
GUI_LoadingIcon_Anim = 0;
GUI_StatusUpdated = 0;
GUI_TextBlink = "|";
alarm[0] = 15;

// Cores
GUI_Color_Anim = 1;
GUI_Color_Begin = global.RPC_Platform;
GUI_Color_End = global.RPC_Platform;
GUI_Color_Platform[ePlatform.WiiU] = $C69400;
GUI_Color_Platform[ePlatform.NintendoSwitch] = $321BF4;
GUI_Color_Platform[ePlatform.Nintendo3DS] = $2A2A2A;

#endregion

// Digitar
TYPING_Title = false;
TYPING_Details = false;
TYPING_FriendCode = false;

// Estados
RPC_IsON = true;
RPC_WasON = false;
RPC_Timestamp_Stored = 0;
RPC_Timestamp_GetNew = true;

// Plataforma
CURRENT_ClientID = "";
event_user(0);