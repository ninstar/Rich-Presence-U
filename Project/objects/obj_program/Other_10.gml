/// @description Carregar plataforma
#region Lista

ini_open(SaveDir + scr_GetPlatform(global.RPC_Platform)+".ini");

// Até 4 (0~3) clientes, 149 (0~148) títulos cada
PLATFORM_TotalTitles = 0;
for(var _c = 0; _c < 3+1; _c++){

	// Clients
	PLATFORM_ClientID[_c] = ini_read_string("CLIENT_"+string(_c), "ID", "");

	// Títulos
	var _findfor = 148;
	for(var _t = 0; _t < _findfor+1; _t++){
	
		// Se não encontrar título nesse slot... Parar loop
		if(ini_read_string("CLIENT_"+string(_c), "T_"+string_add_zeros(_t,3), "") == "")
			break;
		else{
		
			// Adicionar título encontrado a lista
			PLATFORM_Title[_t] = ini_read_string("CLIENT_"+string(_c), "T_"+string_add_zeros(_t,3), "");
			PLATFORM_DetailsPreset[_t] = ini_read_string("CLIENT_"+string(_c), "D_"+string_add_zeros(_t,3), "%DEFAULT%");

			// Incrementar total
			PLATFORM_TotalTitles++;
			
			// Ir para próximo client e buscar mais 149 títulos...
			if(_t == _findfor)
			&&(_c < 4){
				
				_findfor += 148;
				_c++;
			}
		}
	}
}

ini_close();

#endregion

// Fechar em caso de falha
if(PLATFORM_TotalTitles <= 0){
	
	show_message("The client is not available at the moment.");
	game_end();
	exit;
}

// Selecionar título salvo previamente (impedir que ultrapasse total)
CURRENT_TitleString = PLATFORM_Title[clamp(global.RPC_TitleSelected, 0, PLATFORM_TotalTitles-1)];

// Selecionar client ID de acordo com índice de título selecionado
PREVIOUS_ClientID = CURRENT_ClientID;
CURRENT_ClientID = PLATFORM_ClientID[floor(global.RPC_TitleSelected / 149)];

// Baixar icone do título selecionado
GUI_LoadingIcon_Show = true;
if(sprite_exists(GUI_TitleIcon))
	sprite_delete(GUI_TitleIcon);
GUI_TitleIcon = sprite_add(global.NET_Redirect[global.RPC_Platform] + "/" + string_add_zeros(global.RPC_TitleSelected, 3)+".png", 1, false, true, 0, 0);

// Gerar novo timestamp
RPC_Timestamp_GetNew = true;