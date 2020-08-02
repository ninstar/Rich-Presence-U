#macro Version 60
#macro VersionString "0.6.0"
#macro SaveDir game_save_id

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

	switch(os_get_language()){
	
		case("pt"):

		// [PT] Português
		global.DLG_FIELD_Title = "Título";
		global.DLG_FIELD_Details = "Detalhes";
		global.DLG_FIELD_CustomTitle = "Título Personalizado";
		global.DLG_FIELD_FriendCode = "Friend Code";
		global.DLG_FIELD_ElapsedTime = "Tempo Decorrido";
		global.DLG_FIELD_HideRPC = "Ocultar Status";
		
		global.DLG_TIP_Empty = "Vázio";
		global.DLG_TIP_Search = "Busca";
		
		global.DLG_Connection = "Você deve estar conectado à Internet para usar este aplicativo.";
		global.DLG_UpdateNotification = "Atualização Disponível";
		global.DLG_Update = "Uma nova atualização está disponível, ela necessária para que o aplicativo continue funcionando. Você será redirecionado para a página de download ao pressionar 'Sim'.";
		global.DLG_ClientError = "O client não está disponível, feche o aplicativo e tente novamente mais tarde.";

		break;
		case("es"):

		// [ES] Español
		global.DLG_FIELD_Title = "Título";
		global.DLG_FIELD_Details = "Detalles";
		global.DLG_FIELD_CustomTitle = "Título Personalizado";
		global.DLG_FIELD_FriendCode = "Friend Code";
		global.DLG_FIELD_ElapsedTime = "Tiempo Transcurrido";
		global.DLG_FIELD_HideRPC = "Ocultar Status";
		
		global.DLG_TIP_Empty = "Vacío";
		global.DLG_TIP_Search = "Busca";

		global.DLG_Connection = "Debe estar conectado al internet para utilizar esta aplicación.";
		global.DLG_UpdateNotification = "Actualización Disponible";
		global.DLG_Update =  "Una actualización nueva esta disponible, esta actualización es necesaria para que la aplicación continúe funcionando. Al oprimir 'Si' usted será redirigido a la página de descarga.";
		global.DLG_ClientError = "El cliente no está disponible, cierra la aplicación e intente nuevamente más tarde.";

		break;
		default:

		// [??] English
		global.DLG_FIELD_Title = "Title";
		global.DLG_FIELD_Details = "Details";
		global.DLG_FIELD_CustomTitle = "Custom Title";
		global.DLG_FIELD_FriendCode = "Friend Code";
		global.DLG_FIELD_ElapsedTime = "Elapsed Time";
		global.DLG_FIELD_HideRPC = "Hide Status";
		
		global.DLG_TIP_Empty = "Empty";
		global.DLG_TIP_Search = "Search";

		global.DLG_Connection = "You must be connected to the internet in order to use this application.";
		global.DLG_UpdateNotification = "Update Available";
		global.DLG_Update = "A new update is available, this update is necessary for the application to continue working. By pressing 'Yes' you will be redirected to the download page.";
		global.DLG_ClientError = "The client is not available, close the application and try again later.";

		break;
	}

#endregion
#region Global Functions

/// @param local_override
function scr_NetConfig(argument0){

	ini_open(SaveDir+"NETWORK.cfg");

	global.NET_URL_About = ini_read_string("URLS", "about", "hpps://");
	global.NET_Update_Version = ini_read_real("UPDATE", "version", Version);
	global.NET_Update_Mandatory = ini_read_real("UPDATE", "mandatory", 0);
	global.NET_Update_Download = ini_read_string("UPDATE", "download", "hpps://");
	global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "hpps://");
	global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "hpps://");
	global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "hpps://");
	
	ini_close();

	// Custom about link
	if(argument0)
	&&(file_exists(program_directory+"\\NETWORK.cfg")){
	    
		ini_open(program_directory+"\\NETWORK.cfg");
	
		global.NET_Redirect[ePlatform.WiiU] = ini_read_string("REDIRECT", "wiiu", "hpps://");
		global.NET_Redirect[ePlatform.NintendoSwitch] = ini_read_string("REDIRECT", "switch", "hpps://");
		global.NET_Redirect[ePlatform.Nintendo3DS] = ini_read_string("REDIRECT", "3ds", "hpps://");
	
		ini_close();
	}
}
	
/// @param save
/// @param allow_platform_change
function scr_UserConfig(argument0, argument1){

	// Platform
	var _Platform = string_upper( scr_GetPlatform(global.RPC_Platform) );

	if(argument0){

		// Save
		ini_open(SaveDir+"USER.ini")
		
		ini_write_real("RPC_"+_Platform, "TitleID", global.RPC_TitleSelected);
		ini_write_string("RPC_"+_Platform, "FriendCode", global.RPC_FriendCode);
		ini_write_real("RPC_"+_Platform, "ElapsedTime", global.RPC_ElapsedTime);

		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", global.RPC_DetailsMode);
		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", global.RPC_DetailsOnline);
		ini_write_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", global.RPC_DetailsString);
	
		ini_close();
	}
	else{

		// Load
		ini_open(SaveDir+"USER.ini");
		
		global.RPC_TitleSelected = ini_read_real("RPC_"+_Platform, "TitleID", 0);
		global.RPC_FriendCode = ini_read_string("RPC_"+_Platform, "FriendCode", "");
		global.RPC_ElapsedTime = ini_read_real("RPC_"+_Platform, "ElapsedTime", true);

		global.RPC_DetailsMode = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", eDetails.Custom);
		global.RPC_DetailsOnline = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", false);
		global.RPC_DetailsString = ini_read_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", "");

		ini_close();
	}
}
	
/// @param platform
function scr_GetPlatform(argument0){

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
function scr_GetFriendCode(argument0, argument1){

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

/// @param number
/// @param digits
function string_add_zeros(argument0, argument1){

	return string_replace_all( string_format(argument0, argument1, 0), " ", "0")
}

#endregion