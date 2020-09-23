#macro Version 62
#macro VersionString "0.6.2"
#macro DirSave game_save_id
#macro DirApp working_directory+"\\"

enum ePlatform {

	WiiU,
	NintendoSwitch,
	Nintendo3DS
}

enum eDetails {

	Single,
	Multi,
	Custom
}

enum eOption {

	NONE,
	About,
	Theme,
	Update,
	Platform,
	TitleIcon,
	Title,
	Details,
	FriendCode,
	ElapsedTime,
	HideRPC,
	ApplyRPC
}

enum eField {

	NONE,
	Title,
	Details,
	FriendCode,
	Platform
}

#region Translations

	global.OutputMessage = ds_map_create();

	switch(os_get_language()){
	
		case("pt"):

		// [PT] Português
		global.OutputMessage[? "Field_Title"] = "Título";
		global.OutputMessage[? "Field_Details"] = "Detalhes";
		global.OutputMessage[? "Field_TitleC"] = "Título Personalizado";
		global.OutputMessage[? "Field_FriendCode"] = "Friend Code";
		global.OutputMessage[? "Field_ElapsedTime"] = "Tempo Decorrido";
		global.OutputMessage[? "Field_HideRPC"] = "Ocultar Status";
		
		global.OutputMessage[? "Hint_Empty"] = "Vazio";
		global.OutputMessage[? "Hint_Search"] = "Busca";
		
		global.OutputMessage[? "Tool_Cut"] = "Recortar";
		global.OutputMessage[? "Tool_Copy"] = "Copiar";
		global.OutputMessage[? "Tool_Paste"] = "Colar";
		
		global.OutputMessage[? "Error_Application"] = "Um ou mais componentes estão faltando, reinstale o aplicativo e tente novamente.";
		global.OutputMessage[? "Error_Connection"] = "Você deve estar conectado à Internet para usar este aplicativo.";
		global.OutputMessage[? "Error_Client"] = "O client não está disponível, feche o aplicativo e tente novamente mais tarde.";
		
		global.OutputMessage[? "Update"] = "Atualização Disponível";
		global.OutputMessage[? "Update_Mandatory"] = "Uma nova atualização está disponível, ela necessária para que o aplicativo continue funcionando. Você será redirecionado para a página de download ao pressionar 'Sim'.";
		
		break;
		case("es"):

		// [ES] Español
		global.OutputMessage[? "Field_Title"] = "Título";
		global.OutputMessage[? "Field_Details"] = "Detalles";
		global.OutputMessage[? "Field_TitleC"] = "Título Personalizado";
		global.OutputMessage[? "Field_FriendCode"] = "Friend Code";
		global.OutputMessage[? "Field_ElapsedTime"] = "Tiempo Transcurrido";
		global.OutputMessage[? "Field_HideRPC"] = "Ocultar Status";
		
		global.OutputMessage[? "Hint_Empty"] = "Vacío";
		global.OutputMessage[? "Hint_Search"] = "Busca";
		
		global.OutputMessage[? "Tool_Cut"] = "Cortar";
		global.OutputMessage[? "Tool_Copy"] = "Copiar";
		global.OutputMessage[? "Tool_Paste"] = "Pegar";
		
		global.OutputMessage[? "Error_Application"] = "Faltan uno o más componentes, reinstale la aplicación e intente nuevamente.";
		global.OutputMessage[? "Error_Connection"] = "Debe estar conectado al internet para utilizar esta aplicación.";
		global.OutputMessage[? "Error_Client"] = "El cliente no está disponible, cierra la aplicación e intente nuevamente más tarde.";

		global.OutputMessage[? "Update"] = "Actualización Disponible";
		global.OutputMessage[? "Update_Mandatory"] =  "Una actualización nueva esta disponible, esta actualización es necesaria para que la aplicación continúe funcionando. Al oprimir 'Si' usted será redirigido a la página de descarga.";

		break;
		default:

		// [??] English
		global.OutputMessage[? "Field_Title"] = "Title";
		global.OutputMessage[? "Field_Details"] = "Details";
		global.OutputMessage[? "Field_TitleC"] = "Custom Title";
		global.OutputMessage[? "Field_FriendCode"] = "Friend Code";
		global.OutputMessage[? "Field_ElapsedTime"] = "Elapsed Time";
		global.OutputMessage[? "Field_HideRPC"] = "Hide Status";
		
		global.OutputMessage[? "Hint_Empty"] = "Empty";
		global.OutputMessage[? "Hint_Search"] = "Search";

		global.OutputMessage[? "Tool_Cut"] = "Cut";
		global.OutputMessage[? "Tool_Copy"] = "Copy";
		global.OutputMessage[? "Tool_Paste"] = "Paste";

		global.OutputMessage[? "Error_Application"] = "One or more components are missing, reinstall the application and try again.";
		global.OutputMessage[? "Error_Connection"] = "You must be connected to the internet in order to use this application.";
		global.OutputMessage[? "Error_Client"] = "The client is not available, close the application and try again later.";
		
		global.OutputMessage[? "Update"] = "Update Available";
		global.OutputMessage[? "Update_Mandatory"] = "A new update is available, this update is necessary for the application to continue working. By pressing 'Yes' you will be redirected to the download page.";

		break;
	}

#endregion
#region Repository

global.Repository = "";
var _FileText = -1;
var _Repo = DirApp+"meta.dat";

if(file_exists(_Repo)){
	
	_FileText = file_text_open_read(_Repo);
	global.Repository = file_text_read_string(_FileText);
	file_text_close(_FileText);
}

#endregion
#region Global Functions

/// @param number
/// @param digits
function string_zeros(argument0, argument1){

	return string_replace_all( string_format(argument0, argument1, 0), " ", "0")
}

/// @param local_override
function sNetConfig(argument0){

	// Default
	ini_open(DirSave+"NETWORK.cfg");

	global.NET_URL_About = ini_read_string("URLS", "about", "url://");
	global.NET_URL_Repo = ini_read_string("URLS", "repo", "url://");
	global.NET_Update_Version = ini_read_real("UPDATE", "version", Version);
	global.NET_Update_Mandatory = ini_read_real("UPDATE", "mandatory", 0);
	global.NET_Update_Download = ini_read_string("UPDATE", "download", "url://");
	global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "url://");
	global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "url://");
	global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "url://");
	
	ini_close();

	// Custom
	if(argument0)
	&&(file_exists(DirApp+"NETWORK.cfg")){
	    
		ini_open(DirApp+"NETWORK.cfg");
	
		if(ini_key_exists("REDIRECT", "wiiu"))		global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "url://");
		if(ini_key_exists("REDIRECT", "switch"))	global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "url://");
		if(ini_key_exists("REDIRECT", "3ds"))		global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "url://");
	
		ini_close();
	}
}
	
/// @param save
/// @param allow_platform_change
function sUserConfig(argument0, argument1){

	// Platform
	var _Platform = string_upper( sGetPlatform(global.RPC_Platform) );

	if(argument0){

		// Save
		ini_open(DirSave+"USER.ini")
		
		ini_write_real("RPC_"+_Platform, "TitleID", global.RPC_TitleSelected);
		ini_write_string("RPC_"+_Platform, "FriendCode", global.RPC_FriendCode);
		ini_write_real("RPC_"+_Platform, "ElapsedTime", global.RPC_ElapsedTime);

		ini_write_real("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_M", global.RPC_DetailsMode);
		ini_write_real("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_O", global.RPC_DetailsOnline);
		ini_write_string("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_C", global.RPC_DetailsString);
	
		ini_close();
	}
	else{

		// Load
		ini_open(DirSave+"USER.ini");
		
		global.RPC_TitleSelected = ini_read_real("RPC_"+_Platform, "TitleID", 0);
		global.RPC_FriendCode = ini_read_string("RPC_"+_Platform, "FriendCode", "");
		global.RPC_ElapsedTime = ini_read_real("RPC_"+_Platform, "ElapsedTime", true);

		global.RPC_DetailsMode = ini_read_real("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_M", eDetails.Custom);
		global.RPC_DetailsOnline = ini_read_real("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_O", false);
		global.RPC_DetailsString = ini_read_string("RPC_"+_Platform, string_zeros(global.RPC_TitleSelected, 3)+"_C", "");

		ini_close();
	}
}
	
/// @param platform
function sGetPlatform(argument0){

	var _p = "";
	switch(argument0){
	
		case(ePlatform.WiiU):				_p = "wiiu";		break;
		case(ePlatform.NintendoSwitch):		_p = "switch";		break;
		case(ePlatform.Nintendo3DS):		_p = "3ds";			break;
	}
	return _p;
}

/// @param platform
/// @param fc
function sGetFriendCode(argument0, argument1){

	var _fc = "";
	if(argument0 != ePlatform.WiiU){

		// 3DS / Switch
		var _fc_convert = "____-____-____";
		for(var _d = 0; _d < 12+2; _d++){
	
			if(_d < string_length(argument1))
			&&(argument1 != "")
				_fc_convert = string_replace(_fc_convert, "_", string_char_at(argument1, _d+1));
			else
				break;
		}
	
		// SW - ...
		if(argument0 == ePlatform.NintendoSwitch)
			_fc = "SW-"+_fc_convert;
		else
			_fc = _fc_convert;
	}
	else
		_fc = argument1;

	return _fc;
}

#endregion