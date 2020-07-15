/// @description GUI

var _BGc = merge_color(GUI_Color_Platform[GUI_Color_Begin], GUI_Color_Platform[GUI_Color_End], GUI_Color_Anim);
draw_sprite_stretched_ext(spr_Background, 0, -64, -64, 720+64, 280+64, _BGc, 1);

draw_set_font(fnt_Default);

#region Layout

// Title
draw_text(21, 52-24, global.DLG_FIELD_Title);
draw_sprite(spr_Content_Field, 0, 21, 52);

// Details
draw_text(21, 129-24, global.DLG_FIELD_Details);
draw_sprite(spr_Content_Field, 0, 21, 129);
var _CustomDetails = 0;
if(global.RPC_DetailsMode == eDetails.Custom)
	_CustomDetails = 1;
draw_sprite(spr_CustomDetails, _CustomDetails, 499, 136);

if(_CustomDetails){

	var _Text = global.RPC_DetailsString;
	if(TYPING_Details)
	&&(string_length(global.RPC_DetailsString) < 64)
		_Text = global.RPC_DetailsString + GUI_TextBlink;
		
	if(global.RPC_DetailsString != "")
	||(TYPING_Details){
	
		// Ajustar largura do texto
		var _TextScale = 1; 
		if(string_width(global.RPC_DetailsString) > 464)
			_TextScale = 464 / string_width(global.RPC_DetailsString);
		draw_text_transformed(29, 139, _Text, _TextScale, 1, 0);
	}
	else{

		var _TypeDetails = global.DLG_TIP_Details;
		if(CURRENT_TitleString == "%CUSTOM%")
			_TypeDetails = global.DLG_TIP_DetailsTitle;
	
		draw_set_alpha(.5);
		draw_text(29, 139, _TypeDetails);
		draw_set_alpha(1);
	}
}
else{
	
	// Predefinidos
	var _1P = false;
	var _2P = false;
	var _ON = false;
	if(global.RPC_DetailsMode == eDetails.Multi)
		_2P = true;
	else
		_1P = true;
	if(global.RPC_DetailsOnline)
		_ON = true;

	draw_sprite(spr_Content_Option, 2+_1P, 31, 143);
	draw_sprite(spr_Content_Option, 2+_2P, 184, 143);
	draw_sprite(spr_Content_Option, _ON, 337, 143);

	// Ajustar largura dos textos	
	var _1P_Scale = 1;
	if(string_width(PRESET_Details_1P) > 128)
		_1P_Scale = 128 / string_width(PRESET_Details_1P);
	var _2P_Scale = 1;
	if(string_width(PRESET_Details_2P) > 128)
		_2P_Scale = 128 / string_width(PRESET_Details_2P);
	var _ON_Scale = 1;
	if(string_width(PRESET_Details_ON) > 128)
		_ON_Scale = 128 / string_width(PRESET_Details_ON);

	draw_text_transformed(51, 139, PRESET_Details_1P, _1P_Scale, 1, 0);
	draw_text_transformed(204, 139, PRESET_Details_2P, _2P_Scale, 1, 0);
	draw_text_transformed(357, 139, PRESET_Details_ON, _ON_Scale, 1, 0);
}

// Friend Code
draw_text(21, 206-24, global.DLG_FIELD_FriendCode);
draw_sprite(spr_Content_Field, 1, 21, 206);
draw_sprite(spr_FriendCode, global.RPC_Platform, 348, 214);

var _FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode);
if(TYPING_FriendCode)
&&(global.RPC_Platform == ePlatform.WiiU)
&&(string_length(global.RPC_FriendCode) < 16)
	_FC = scr_GetFriendCode(global.RPC_Platform, global.RPC_FriendCode) + GUI_TextBlink;

if(global.RPC_FriendCode != "")
||(TYPING_FriendCode)
	draw_text(29, 216, _FC);
else{

	// Não definido
	draw_set_alpha(.5);
	draw_text(29, 216, global.DLG_TIP_FriendCode);	
	draw_set_alpha(1);
}

// Elapsed Time
draw_set_halign(fa_middle);
draw_text(458, 207-26, global.DLG_FIELD_ElapsedTime);
draw_set_halign(fa_left);
draw_sprite(spr_ElapsedTime_Field, 0, 423, 207);
draw_sprite(spr_ElapsedTime_Option, global.RPC_ElapsedTime, 429 + (32*GUI_Slide_ElapsedTime), 213);

// Rich Presence
draw_sprite(spr_RichPresence_Option, 0, 546, 190);
draw_sprite(spr_RichPresence_State, RPC_IsON, 582 + (16*GUI_Slide_State), 242);
var _UpState = false;
if(os_is_network_connected())
&&(RPC_IsON)
	_UpState = true;
draw_sprite(spr_RichPresence_Option, 1, 628, 190);
draw_sprite_ext(spr_RichPresence_State, 2 + _UpState, 681, 243, 1, 1, 0, c_white, GUI_StatusUpdated / (60*1));

// Outros
draw_sprite(spr_About_Option, 0, 446, 19);
draw_sprite(spr_Platform_Small, global.RPC_Platform, 480, 20);

// Atualização
if(global.NET_Update_Version > Version){
	
	draw_sprite(spr_UpdateNotification, 0, 242, 19);
	
	// Ajustar largura do texto				
	var _TextString = string_upper(global.DLG_FIELD_UpdateNotification);
	var _TextScale = .8;	
	if(string_width(_TextString) > 170)
		_TextScale = ( 170 / string_width(_TextString) ) * .95;
	
	draw_set_color($00D63E);
	draw_set_halign(fa_middle);
	draw_text_transformed(242+3 + (170/2), 22, _TextString, _TextScale, .8, 0);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
}

// Icone
draw_sprite(spr_TitleIcon_Field, 0, 545, 20);
if(GUI_LoadingIcon_Show){

	// Loading...
	GUI_LoadingIcon_Anim -= 8;
	draw_sprite_ext(spr_TitleIcon_Loading, 0, 545 + (154/2), 20 + (154/2), 1, 1, GUI_LoadingIcon_Anim, _BGc, 1);
}
else{
	
	// Preview
	if(sprite_exists(GUI_TitleIcon))
		draw_sprite_stretched(GUI_TitleIcon, 0, 545+8, 20+8, 138, 138);
}

#endregion
#region Lista de títulos

//SE estiver digitando...
if(TYPING_Title)
&&(!GUI_About_Show){
		
	var _Select = -1;
		
	// Nenhum título digitado
	if(keyboard_string == ""){
		
		draw_set_alpha(.5)
		draw_text(21+16, 52+10, global.DLG_TIP_Title);
		draw_set_alpha(1);
	}
	
	// Ajustar largura do texto
	var _TextScale = 1;
	if(string_width(keyboard_string) > 500)
		_TextScale = 500 / string_width(keyboard_string);
	draw_text_transformed(29, 62, keyboard_string + GUI_TextBlink, _TextScale, 1, 0);
		
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
				_Text = "["+global.DLG_CustomTitle+"]";
		
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
				draw_set_alpha(.3);
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
		_Title = "["+global.DLG_CustomTitle+"] "+global.DLG_UseDetails;
	
	// Ajustar largura do texto
	var _TextScale = 1;
	if(string_width(_Title) > 490)
		_TextScale = 490 / string_width(_Title);
	draw_text_transformed(21+8, 52+10, _Title, _TextScale, 1, 0);
}

#endregion
#region Janelas

if(GUI_About_Anim > 0)
||(GUI_Platforms_Anim > 0){

	// Foreground
	draw_sprite_stretched_ext(spr_Background, 0, -64, -64, 720+64, 280+64, _BGc, 1*(GUI_About_Anim+GUI_Platforms_Anim));

	// Sobre
	if(GUI_About_Anim > 0){
		
		draw_sprite(spr_About_Information, 0, 0, (300 - (300*GUI_About_Anim) ));
	
		draw_set_halign(fa_right);
		draw_text_transformed(489, 72 + (300 - (300*GUI_About_Anim) ), VersionString, .9, .9, 0);
		
		draw_set_halign(fa_middle);
		draw_text(720/2, 228 + (300 - (300*GUI_About_Anim) ), "• "+global.DLG_About+" •");
		
		draw_set_halign(fa_left);
	}
	// Plataformas
	if(GUI_Platforms_Anim > 0){
	
		draw_sprite(spr_Platform_Big, 3, 119, 76 + (300 - (300*GUI_Platforms_Anim) ));
		draw_sprite(spr_Platform_Big, 1, 296, 76 + (400 - (400*GUI_Platforms_Anim) ));
		draw_sprite(spr_Platform_Big, 2, 473, 76 + (500 - (500*GUI_Platforms_Anim) ));
	}
}

#endregion