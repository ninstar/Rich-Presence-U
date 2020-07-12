/// @description Atualizar estado
#region Checar estado

// Se RPC estiver ligado...
if(RPC_IsON){

	// Desliga-lo se Client ID tiver sido alterado
	if(CURRENT_ClientID != PREVIOUS_ClientID){

		if(RPC_WasON){
			
			discord_presence_shutdown();
			RPC_WasON = false;
		}
		
		PREVIOUS_ClientID = CURRENT_ClientID;
	}

	// Liga-lo novamente se Client ID for válido
	if(CURRENT_ClientID != "")
	&&(CURRENT_ClientID != "0"){

		if(!RPC_WasON){
			
			discord_presence_init(CURRENT_ClientID);
			RPC_WasON = true;
		}
	}
	else{

		show_message_async(ErrorClient);
		exit;
	}
}
else
	exit;
	
#endregion

// Usar detalhes como título
if(PLATFORM_DetailsPreset[global.RPC_TitleSelected] == "%TITLE%"){
		
	//Apenas incluir descrição customizada como título (se existir)
	var _Title = "";
	if(global.RPC_DetailsString != "")
		_Title =  global.RPC_DetailsString;
			
	// RPC
	discord_set_details(_Title);
	discord_set_state("");
}
else{
	
	// Detalhes customizado / predefinido
	var _Details = "";
	if(PLATFORM_DetailsPreset[global.RPC_TitleSelected] != "%DEFAULT%"){
	
		// Usar detalhes predefinido do título se existir detalhe customizado
		if(global.RPC_DetailsString != "")
			_Details = PLATFORM_DetailsPreset[global.RPC_TitleSelected]+global.RPC_DetailsString;
	}
	else{
		
		// + (Online)
		var _Online = "";
		if(global.RPC_DetailsOnline == true)
			_Online = PRESET_Details_ON;
	
		// Detalhes ( 1P / 2P / Custom )
		if(global.RPC_DetailsMode == eDetails.Single)
			_Details = PRESET_Details_1P+_Online;
		else if(global.RPC_DetailsMode == eDetails.Multi)
			_Details = PRESET_Details_2P+_Online;
		else
			_Details = global.RPC_DetailsString;
	}
	
	// RPC
	discord_set_details(PLATFORM_Title[global.RPC_TitleSelected]);
	discord_set_state(_Details);
}

// Icone do título + Versão
discord_set_image_large(string_add_zeros(global.RPC_TitleSelected, 3));
discord_set_text_large("Rich Presence U - " + VersionString);

// Icone pequeno + Friend Code
var _FC_Icon = "";
var _FC = "";
if(global.RPC_FriendCode != ""){
	
	_FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode);
	_FC_Icon = "fc";
}
discord_set_image_small(_FC_Icon);
discord_set_text_small(_FC);

// Gerar novo timestamp se necessário
if(RPC_Timestamp_GetNew){
	
	RPC_Timestamp_Stored = discord_get_timestamp_now();
	RPC_Timestamp_GetNew = false;
}

// Tempo
if(global.RPC_ElapsedTime)
	discord_set_timestamp_start(RPC_Timestamp_Stored);
else
	discord_set_timestamp_start(0);

// Atualizar no Discord
discord_presence_update();