/// @description GUI
draw_set_font(fnt_default);
var _BGc = merge_color(GUI_Color_Platform[GUI_Color_Begin], GUI_Color_Platform[GUI_Color_End], GUI_Color_Anim);
draw_sprite_stretched_ext(spr_background, 0, -64, -64, 720+64, 280+64, _BGc, 1);

#region Layout principal

// Base
draw_sprite(spr_layout, global.RPC_Platform, 0, 0);

// Atualização
if(global.NET_Update_Version > Version)
	draw_sprite(spr_appupdate, 0, 303, 19);

// Detalhes
var _Custom = false;
var _CustomLocked = false;
if(global.RPC_DetailsMode == eDetails.Custom)
||(PLATFORM_DetailsPreset[global.RPC_TitleSelected] != "%DEFAULT%"){
	
	_Custom = true;
	
	// Apenas customizado
	if(PLATFORM_DetailsPreset[global.RPC_TitleSelected] != "%DEFAULT%")
		_CustomLocked = true;

	var _Text = global.RPC_DetailsString;
	if(TYPING_Details)
	&&(string_length(global.RPC_DetailsString) < 64)
		_Text = global.RPC_DetailsString + GUI_TextBlink;
		
	if(global.RPC_DetailsString != "")
	||(TYPING_Details){
	
		// Ajustar largura do texto
		var _TextScale = 1; 
		if(string_width(global.RPC_DetailsString) > 410)
			_TextScale = 410 / string_width(global.RPC_DetailsString);
	
		// Texto
		draw_text_transformed(21+8, 129+10, _Text, _TextScale, 1, 0);
	}
	else{

		draw_set_alpha(0.5);
		draw_text(21+8, 129+10, "Type a custom status here.");	
		draw_set_alpha(1);
	}
}

draw_sprite(spr_details, _Custom, 21, 129);

var _Online = -16;
if(_Custom)
	_Online = 510;
else{
	
	// Detalhes predefinido (1P/2P)
	var _Preset = 152;
	if(global.RPC_DetailsMode == eDetails.Multi)
		_Preset = 299;

	draw_sprite(spr_details_option, 0, _Preset, 144);
	
	// Online (OFF/ON)
	if(global.RPC_DetailsOnline)
		_Online = 401;
}

draw_sprite(spr_details_option, 1+_CustomLocked, _Online, 143);

// Friend Code
var _FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode);
if(TYPING_FriendCode)
&&(global.RPC_Platform == ePlatform.WiiU)
&&(string_length(global.RPC_FriendCode) < 16)
	_FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode) + GUI_TextBlink;

if(global.RPC_FriendCode != "")
||(TYPING_FriendCode)
	draw_text(21+8, 206+10, _FC);
else{

	//Não definido
	draw_set_alpha(0.5);
	draw_text(21+8, 206+10, "Type your ID here.");	
	draw_set_alpha(1);
}

// Elapsed Time
draw_sprite(spr_elapsedtime, global.RPC_ElapsedTime, 423, 207);

// Estado atualizado
var _UpState = false;
if(os_is_network_connected())
&&(RPC_IsON)
	_UpState = true;

draw_sprite(spr_rpcon, RPC_IsON, 546, 186);
draw_sprite_ext(spr_rpcupdated, _UpState, 546, 186, 1, 1, 0, c_white, GUI_StatusUpdated/(60*1));

// Icone do título
if(GUI_LoadingIcon_Show){

	// Loading...
	GUI_LoadingIcon_Anim -= 8;
	draw_sprite_ext(spr_titleicon_anim, 0, 553+(139/2), 27+(139/2), 1, 1, GUI_LoadingIcon_Anim, _BGc, 1);
}
else{
	
	if(sprite_exists(GUI_TitleIcon))
		draw_sprite_stretched(GUI_TitleIcon, 0, 553, 27, 139, 139);
}
		
#endregion
#region Lista de títulos

//SE estiver digitando...
if(TYPING_Title)
&&(!GUI_About_Show){
		
	var _Select = -1;
		
	// Nenhum título digitado
	if(keyboard_string == ""){
		
		draw_set_alpha(0.5)
		draw_text(21+16, 52+10, "Keep typing to find a title.");
		draw_set_alpha(1);
	}
	
	// Ajustar largura do texto
	var _TextScale = 1;
	if(string_width(keyboard_string) > 500)
		_TextScale = 500 / string_width(keyboard_string);
	draw_text_transformed(21+8, 52+10, keyboard_string + GUI_TextBlink, _TextScale, 1, 0);
		
	// Buscar por títulos
	_QUEUE_TotalFound = 0;
	_QUEUE_TitleString[0] = "";
	_QUEUE_TitleIndex[0] = 0;
	for(var i = 0; i < PLATFORM_TotalTitles; ++i){
	
		// Procurar por títulos que comecem pelas letras digitas
		if(string_pos(string_lower(keyboard_string), string_lower(PLATFORM_Title[i])) > 0){
	
			// Parar ao encontrar 8 títulos
			if(_QUEUE_TotalFound >= 8)
				break;
			
			// Adicionar título encontrado a lista
			_QUEUE_TitleString[_QUEUE_TotalFound] = PLATFORM_Title[i];
			_QUEUE_TitleIndex[_QUEUE_TotalFound] = i;
		
			// Próximo...
			_QUEUE_TotalFound++;
		}
	}
		
	// Lista
	if(_QUEUE_TotalFound > 0){
		
		//Fundo
		draw_rectangle(21, 98, 21+512, 98+(20*_QUEUE_TotalFound), false);
	
		// [ATALHO] Selecionar o primeiro título da busca
		if(keyboard_check_pressed(vk_enter))
			_Select = 0;
	
		// Títulos encontrados
		for(var _q = 0; _q < _QUEUE_TotalFound; ++_q){

			var _Text = _QUEUE_TitleString[_q];
			if(_QUEUE_TitleString[_q] == "%CUSTOM%")
				_Text = "[Custom Title]";
		
			// Ajustar largura do texto				
			var _TextScale = 1;	
			if(string_width(_Text) > 490)
				_TextScale = 490 / string_width(_Text);
		
			draw_set_color(c_dkgray);
			draw_text_transformed(21+8, 98+(20*_q), _Text, _TextScale, 1, 0);
			draw_set_color(c_white);
		
			// Seletor
			if(point_in_rectangle(mouse_x, mouse_y, 21, 98+(20*_q), 21+512, 98+(20*_q)+19)){
			
				// Fundo
				draw_set_color(c_lime);
				draw_set_alpha(0.3);
				draw_rectangle(21, 98+(20*_q), 21+512, 98+(20*_q)+20, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
		
				// Selecionar título
				if(mouse_check_button_released(mb_any))
				&&(TYPING_Title)
					_Select = _q;
			}
		}
	}

	if(_Select > -1){

		// Salvar detalhes do título anterior
		var _Platform = string_upper( scr_GetPlatform(global.RPC_Platform) );
		ini_open(SaveDir+"USER.ini")
		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", global.RPC_DetailsMode);
		ini_write_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", global.RPC_DetailsOnline);
		ini_write_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", global.RPC_DetailsString);
		
		// Selecionar título
		global.RPC_TitleSelected = _QUEUE_TitleIndex[_Select];
		CURRENT_TitleString = _QUEUE_TitleString[_Select];

		// Carregar detalhes do título atual
		global.RPC_DetailsMode = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_M", eDetails.Custom);
		global.RPC_DetailsOnline = ini_read_real("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_O", false);
		global.RPC_DetailsString = ini_read_string("RPC_"+_Platform, string_add_zeros(global.RPC_TitleSelected, 3)+"_C", "");
		ini_close();
	
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
		
		// Limpar texto digitado
		keyboard_string = "";
			
		// Parar de digitar
		TYPING_Title = false;
	}

	//Parar de digitar
	if(mouse_check_button_released(mb_any))
	&&(TYPING_Title > 0)
		TYPING_Title -= 1;
}
else{
	
	var _Title = CURRENT_TitleString;
	if(CURRENT_TitleString == "%CUSTOM%")
		_Title = "[Custom Title] Use 'Details' bar.";
	
	// Ajustar largura do texto
	var _TextScale = 1;
	if(string_width(_Title) > 490)
		_TextScale = 490 / string_width(_Title);
	draw_text_transformed(21+8, 52+10, _Title, _TextScale, 1, 0);
}

#endregion

// Janelas
draw_sprite_stretched_ext(spr_background, 0, -64, -64, 720+64, 280+64, _BGc, 1*(GUI_About_Anim+GUI_Platforms_Anim));
draw_sprite(spr_about, 0, 0, 280+(-280*GUI_About_Anim));
draw_sprite(spr_platforms, 0, 0, 280+(-280*GUI_Platforms_Anim));