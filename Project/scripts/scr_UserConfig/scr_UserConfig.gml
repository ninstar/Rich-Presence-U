/// @param save
/// @param allow_platform_change

// Plataforma
var _Platform = string_upper( scr_GetPlatform(global.RPC_Platform) );

if(argument0){

	// Salvar
	ini_open(SaveDir+"USER.ini")
	
	if(argument1)
		ini_write_real("RPC_GLOBAL", "PlatformID", global.RPC_Platform);

	ini_write_real("RPC_"+_Platform, "TitleID", global.RPC_TitleSelected);
	ini_write_string("RPC_"+_Platform, "FriendCode", global.RPC_FriendCode);
	ini_write_real("RPC_"+_Platform, "ElapsedTime", global.RPC_ElapsedTime);

	ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", global.RPC_DetailsMode);
	ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", global.RPC_DetailsOnline);
	ini_write_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", global.RPC_DetailsString);
	
	ini_close();
}
else{

	// Carregar
	ini_open(SaveDir+"USER.ini");

	if(argument1)
		global.RPC_Platform = ini_read_real("RPC_GLOBAL", "PlatformID", ePlatform.WiiU);
	
	global.RPC_TitleSelected = ini_read_real("RPC_"+_Platform, "TitleID", 0);
	global.RPC_FriendCode = ini_read_string("RPC_"+_Platform, "FriendCode", "");
	global.RPC_ElapsedTime = ini_read_real("RPC_"+_Platform, "ElapsedTime", true);

	global.RPC_DetailsMode = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", eDetails.Custom);
	global.RPC_DetailsOnline = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", false);
	global.RPC_DetailsString = ini_read_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", "");

	ini_close();
}