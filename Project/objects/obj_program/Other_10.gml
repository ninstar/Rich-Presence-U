/// @description Carregar plataforma
#region Lista

ini_open(SaveDir + scr_GetPlatform(global.RPC_Platform)+".ini");

// Até 10 (0~9) clientes, 149 (0~148) títulos cada
PLATFORM_TotalTitles = 0;
var _Offset = 0;
for(var _c = 0; _c < 9+1; _c++){

	// Clients
	PLATFORM_ClientID[_c] = ini_read_string("CLIENT_"+string(_c), "ID", "");

	// Títulos
	for(var _t = _Offset; _t < _Offset + (148+1); _t++){
	
		// Se não encontrar título nesse slot... Parar loop
		if(ini_read_string("CLIENT_"+string(_c), "T_"+string_add_zeros(_t,3), "") == "")
			break;
		else{
		
			// Adicionar título encontrado a lista
			PLATFORM_Title[_t] = ini_read_string("CLIENT_"+string(_c), "T_"+string_add_zeros(_t,3), "");

			// Incrementar total
			PLATFORM_TotalTitles++;
		}
	}
	
	// Buscar mais 149 títulos...
	_Offset = _t;
}

ini_close();

#endregion

// Fechar em caso de falha
if(PLATFORM_TotalTitles <= 0){
	
	show_message(global.DLG_ClientError);
	game_end();
	exit;
}

// Selecionar título salvo previamente (impedir que ultrapasse total)
CURRENT_TitleString = PLATFORM_Title[clamp(global.RPC_TitleSelected, 0, PLATFORM_TotalTitles-1)];

// Selecionar client ID de acordo com índice de título selecionado
PREVIOUS_ClientID = CURRENT_ClientID;
CURRENT_ClientID = PLATFORM_ClientID[floor(global.RPC_TitleSelected / 149)];

// Icone
if(sprite_exists(GUI_TitleIcon))
	sprite_delete(GUI_TitleIcon);
	
// Checar se icone já existe icone no cache
var _CacheIcon = SaveDir+ "cache\\" + scr_GetPlatform(global.RPC_Platform) + "\\" + string_add_zeros(global.RPC_TitleSelected, 3)+".png";
if(file_exists(_CacheIcon))
	GUI_TitleIcon = sprite_add(_CacheIcon, 1, false, true, 0, 0);
else{
	
	// Baixar icone do título selecionado
	GUI_LoadingIcon_Show = true;
	GUI_TitleIcon = sprite_add(global.NET_Redirect[global.RPC_Platform] + "/" + string_add_zeros(global.RPC_TitleSelected, 3)+".png", 1, false, true, 0, 0);
}

// Gerar novo timestamp
RPC_Timestamp_GetNew = true;