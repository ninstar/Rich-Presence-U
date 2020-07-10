/// @description Checar rede
var _Repo = "https://github.com/MarioSilvaGH/Rich-Presence-U/raw/master/";

// Fechar caso esteja desconectado da internet...
if!(os_is_network_connected()){
	
	show_message("You must be connected to the internet in order to use this application.");
	game_end();
}
else{

	DOWNLOAD_File = noone;
	DOWNLOAD_Platform = -1;
	
	// Carregar metadados baixados previamente
	scr_NetConfig(true);

	// Buscar por metadados mais recente
	DOWNLOAD_File = http_get_file(_Repo+"NETWORK.cfg", SaveDir+"NETWORK.cfg");
}