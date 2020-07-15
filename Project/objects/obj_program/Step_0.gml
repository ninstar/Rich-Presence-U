/// @description Interação
if(!GPU_Sleep){
	
	// Não-renderizar
	if(!window_has_focus()){
		
		draw_enable_drawevent(GPU_Sleep);
		GPU_Sleep = true;
	}
}
else{

	// Renderizar
	if(window_has_focus()){
		
		draw_enable_drawevent(GPU_Sleep);
		GPU_Sleep = false;
	}
	else
		exit;
}

#region Animações

// Cor de fundo
GUI_Color_Anim += ( 1-GUI_Color_Anim ) / 6;

// Sobre
if(GUI_About_Show)
	GUI_About_Anim += ( 1-GUI_About_Anim ) / 6;
else
	GUI_About_Anim -= .1 * (GUI_About_Anim > 0);

// Plataformas
if(GUI_Platforms_Show)
	GUI_Platforms_Anim += ( 1-GUI_Platforms_Anim ) / 6;
else
	GUI_Platforms_Anim -= .1 * (GUI_Platforms_Anim > 0);

// Slides
GUI_Slide_ElapsedTime += ( global.RPC_ElapsedTime-GUI_Slide_ElapsedTime ) / 4;
GUI_Slide_State += ( RPC_IsON-GUI_Slide_State ) / 4;

// Estado atualizado
GUI_StatusUpdated -= (GUI_StatusUpdated > 0);

#endregion
#region Janelas

// Sobre
if(GUI_About_Show){
	
	//Controles
	if(mouse_check_button_pressed(mb_any)){
		
		// Fechar
		if(point_in_rectangle(mouse_x, mouse_y, 665, 22, 665+32, 22+32))
			GUI_About_Show = false;
	
		// Abrir página
		if(point_in_rectangle(mouse_x, mouse_y, 129, 14, 129+433, 14+92))
			url_open(global.NET_URL_About);
	}
}

// Plataformas
if(GUI_Platforms_Show){

	// Seleção
	if(mouse_check_button_pressed(mb_any)){
		
		var _choose = -1;
	
		if(point_in_rectangle(mouse_x, mouse_y, 119, 76, 119+128, 76+128))	_choose = 0; // Wii U
		if(point_in_rectangle(mouse_x, mouse_y, 296, 76, 296+128, 76+128))	_choose = 1; // Nintendo Switch
		if(point_in_rectangle(mouse_x, mouse_y, 473, 76, 473+128, 76+128))	_choose = 2; // Nintendo 3DS
		
		// Alterar plataforma
		if(_choose > -1){
			
			if(_choose != global.RPC_Platform){
				
				// Transição de cor
				GUI_Color_Anim = 0;
				GUI_Color_Begin = global.RPC_Platform;
				GUI_Color_End = _choose;
			
				// Salvar definições
				scr_UserConfig(true, false);
		
				// Trocar de plataforma
				global.RPC_Platform = _choose;
		
				// Carregar novas definições e nova lista
				scr_UserConfig(false, false);
				event_user(0);
			}
	
			// Fechar
			GUI_Platforms_Show = false;
		}
	}
}

// Impedir interação com resto da interface enquanto janelas estiverem abertas
if(GUI_About_Show)
||(GUI_About_Anim > 0)
||(GUI_Platforms_Show)
||(GUI_Platforms_Anim > 0)
	exit;

#endregion
#region Atalhos

// [ENTER] Atualizar estado
if(keyboard_check_pressed(vk_enter))
&&(!TYPING_Title)
&&(GUI_StatusUpdated == 0){
		
	// Parar qualquer área que esteja sendo digitada
	TYPING_Details = false;
	TYPING_FriendCode = false;
	
	// Atualizar estado se estiver ligado
	GUI_StatusUpdated = 60*3;
	if(RPC_IsON)
		event_user(1);
}

// [DELETE] Remover texto digitado
if(keyboard_check_pressed(vk_delete))
	keyboard_string = "";

// [ESCAPE] Fechar programa
if(keyboard_check_pressed(vk_escape))
	game_end();
	
#endregion
#region Opções (Cursor)

if(mouse_check_button_released(mb_any))
&&(!TYPING_Title){

	// Parar qualquer área que esteja sendo digitada
	TYPING_Details = false;
	TYPING_FriendCode = false;

	// Atualização do Rich Presence U
	if(point_in_rectangle(mouse_x, mouse_y, 242, 19, 242+192, 19+23))
	&&(global.NET_Update_Version > Version)
		url_open(global.NET_Update_Download);

	// Sobre
	if(point_in_rectangle(mouse_x, mouse_y, 446, 19, 446+23, 19+23))
		GUI_About_Show = true;
	
	// Plataforma
	if(point_in_rectangle(mouse_x, mouse_y, 480, 20, 480+53, 20+21))
		GUI_Platforms_Show = true;

	// Título
	if(point_in_rectangle(mouse_x, mouse_y, 27, 52, 27+512, 52+38)){
		
		// Começar a digitar título
		TYPING_Title = 2;
		TYPING_Details = false;
		TYPING_FriendCode = false;

		// Limpar texto
		keyboard_string = "";
	}

	// Detalhes
	if(global.RPC_DetailsMode == eDetails.Custom){

		// Customizado
		if(point_in_rectangle(mouse_x, mouse_y, 27, 132, 331+95, 132+38)){
		
			// Começar a digitar detalhes
			TYPING_Title = false;
			TYPING_Details = true;
			TYPING_FriendCode = false;
			
			// Usar texto anterior como base
			keyboard_string = global.RPC_DetailsString;
		}
	}
	else{
		
		// Predefinidos
		if(point_in_rectangle(mouse_x, mouse_y, 31, 143, 31+147, 143+18))	global.RPC_DetailsMode = eDetails.Single;
		if(point_in_rectangle(mouse_x, mouse_y, 184, 143, 184+147, 143+18))	global.RPC_DetailsMode = eDetails.Multi;
		if(point_in_rectangle(mouse_x, mouse_y, 337, 143, 337+147, 143+18))	global.RPC_DetailsOnline = !global.RPC_DetailsOnline;
	}
		
	// Detalhes customizado (OFF/ON)
	if(point_in_rectangle(mouse_x, mouse_y, 499, 136, 499+27, 136+30)){

		if(global.RPC_DetailsMode != eDetails.Custom)
			global.RPC_DetailsMode = eDetails.Custom;
		else
			global.RPC_DetailsMode = eDetails.Single;
	}

	// Friend Code
	if(point_in_rectangle(mouse_x, mouse_y, 21, 206, 21+355, 206+38)){
		
		// Começar a digitar friend code
		TYPING_Title = false;
		TYPING_Details = false;
		TYPING_FriendCode = true;
		
		// Usar texto anterior como base
		keyboard_string = global.RPC_FriendCode;
	}

	// Elapsed Time (OFF/ON)
	if(point_in_rectangle(mouse_x, mouse_y, 423, 207, 423+74, 207+41))
		global.RPC_ElapsedTime = !global.RPC_ElapsedTime;
	
	// Rich Presence (OFF/ON)
	if(point_in_rectangle(mouse_x, mouse_y, 546, 190, 546+70, 190+70))
	&&(GUI_StatusUpdated == 0){
		
		RPC_IsON = !RPC_IsON;
		
		// Desligar quando necessário
		if(RPC_WasON){
			
			discord_presence_shutdown();
			RPC_WasON = false;
		}
	}
	
	// Atualizar estado
	if(point_in_rectangle(mouse_x, mouse_y, 628, 190, 628+70, 190+70))
	&&(!TYPING_Title)
	&&(GUI_StatusUpdated == 0){
	
		// Atualizar estado se estiver ligado
		GUI_StatusUpdated = 60*3;
		if(RPC_IsON)
			event_user(1);
	}
}

#endregion
#region Digitar

// Clipboard
if(keyboard_check(vk_control)){

	// Colar
	if(keyboard_check_pressed(ord("V")))
		keyboard_string = clipboard_get_text();
	
	// Cópiar
	if(keyboard_check_pressed(ord("C")))
		clipboard_set_text(keyboard_string);
}

// Detalhes customizado
if(TYPING_Details){
	
	keyboard_string = string_copy(keyboard_string, 0, 64);
	global.RPC_DetailsString = keyboard_string;
}

// Friend Code
if(TYPING_FriendCode){
	
	if(global.RPC_Platform ==  ePlatform.WiiU)
		keyboard_string = string_copy(keyboard_string, 0, 16);
	else
		keyboard_string = string_copy(string_digits(keyboard_string), 0, 12);

	global.RPC_FriendCode = keyboard_string;
}
#endregion