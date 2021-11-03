/// @description Set-up
#region Initilization

// Macros
#macro version_stg "0.7.3"
#macro version_int 103
#macro platform_total 3
#macro included_files program_directory+"\\"

// Enumerators
enum ePLATFORM {

	WiiU,
	NintendoSwitch,
	Nintendo3DS,
}
enum eREGION {
	
	US,
	EU,
	JP,
}
enum eBUTTON {

	None,
	Close,
	Expand,
	Suspend,
	Restart,
	Update,
	Settings,
	Apply,
	
	Platform,
	Details,
	Title,
	
	Status,
	PreserveTime,
	Refresh,
	External,
	
	Console,
	Region,
	
	FriendCode,
	About,
	ElapsedTime,
	
	TitleSearch,
	CustomName,
	Description,
}
enum ePAGE {

	Platform,
	Details,
	Title,
	Settings,
}
enum eTYPE {

	None,
	Console,
	Region,
	FriendCode,
	TitleSearch,
	CustomName,
	Description,
}
	
// Misc
math_set_epsilon(0.0001);
audio_channel_num(0);
gml_release_mode(true);

#endregion
#region Languages

Lang = ds_map_create();
switch(os_get_language()){

	case("pt"):

	// Português
	Lang[? "VERSION"] = "Versão";
	Lang[? "DEVELOPED"] = "Desenvolvido por";

	Lang[? "CUT"] = "Recortar";
	Lang[? "COPY"] = "Copiar";
	Lang[? "PASTE"] = "Colar";

	Lang[? "ERROR"] = "Erro inesperado";
	Lang[? "CONNECTING"] = "Conectando";
	Lang[? "CONNECTED"] = "Conectado";
	Lang[? "DISCONNECTED"] = "Desconectado";
	Lang[? "NETWORK_DOWN"] = "Verifique sua conexão com a rede";
	Lang[? "RESTART_APP"] = "Reinicie o aplicativo";
	Lang[? "INVISIBLE"] = "Invisível";
	Lang[? "PLAYING"] = "Jogando";
	
	Lang[? "PLATFORM"] = "Plataforma";
	Lang[? "DETAILS"] = "Detalhes";
	Lang[? "TITLE"] = "Título";
	Lang[? "UPDATE_APP"] = "Baixar atualização";
	Lang[? "SETTINGS"] = "Configurações";

	Lang[? "STATUS"] = "Visibilidade do status";
	Lang[? "STATUS_TIP"] = "Alterações são aplicadas imediatamente.";
	Lang[? "PRESERVE"] = "Preservar tempo decorrido";
	Lang[? "PRESERVE_TIP"] = "Não será reiniciado ao alterar títulos.";
	Lang[? "REFRESH"] = "Atualizar base de dados";
	Lang[? "REFRESH_TIP"] = "É atualizado automaticamente todos os dias.";
	Lang[? "PAGE"] = "Página oficial";
	Lang[? "NEXT"] = "Próximo";
	Lang[? "UPDATE_STATUS"] = "Atualizar status";
	Lang[? "UPDATE_INVISIBLE"] = "Seu status está invisível";
	Lang[? "UPDATE_DISCONNECT"] = "Você está desconectado";

	Lang[? "CONSOLE"] = "Console";
	Lang[? "REGION"] = "Região de preferência";

	Lang[? "FRIEND_CODE"] = "Friend Code";
	Lang[? "NINTENDO_ID"] = "Nintendo Network ID";
	Lang[? "ABOUT"] = "Link de pesquisa rápida";
	Lang[? "ABOUT_TIP"] = "Exibe um botão no seu status.";
	Lang[? "ELAPSED_TIME"] = "Tempo decorrido";

	Lang[? "SEARCH_TITLE"] = "Buscar título";
	Lang[? "CUSTOM_NAME"] = "Nome personalizado";
	Lang[? "DESCRIPTION"] = "Descrição";
	
	Lang[? "RECENT"] = "Títulos recentes";
	Lang[? "RESULTS"] = "Resultados correspondentes";
	Lang[? "NO_RESULTS"] = "Sem resultados";
	Lang[? "DEFAULT_TITLE"] = "Usar nome personalizado";
	
	Lang[? "WIIU"] = "Wii U";
	Lang[? "NINTENDO_SWITCH"] = "Nintendo Switch";
	Lang[? "NINTENDO_3DS"] = "Nintendo 3DS";
	
	Lang[? "AMERICA"] = "América";
	Lang[? "EUROPE"] = "Europa";
	Lang[? "JAPAN"] = "Japão";
	
	Lang[? "ABOUT_TITLE"] = "Search on";
	Lang[? "ABOUT_INTERNET"] = "Search on the internet";
	
	break;
	default:

	// English
	Lang[? "VERSION"] = "Version";
	Lang[? "DEVELOPED"] = "Developed by";

	Lang[? "CUT"] = "Cut";
	Lang[? "COPY"] = "Copy";
	Lang[? "PASTE"] = "Paste";

	Lang[? "ERROR"] = "Unexpected error";
	Lang[? "CONNECTING"] = "Connecting";
	Lang[? "CONNECTED"] = "Connected";
	Lang[? "DISCONNECTED"] = "Disconnected";
	Lang[? "NETWORK_DOWN"] = "Check your internet connection";
	Lang[? "RESTART_APP"] = "Restart the application";
	Lang[? "INVISIBLE"] = "Invisible";
	Lang[? "PLAYING"] = "Playing";
	
	Lang[? "PLATFORM"] = "Platform";
	Lang[? "DETAILS"] = "Details";
	Lang[? "TITLE"] = "Title";
	Lang[? "UPDATE_APP"] = "Download update";
	Lang[? "SETTINGS"] = "Settings";

	Lang[? "STATUS"] = "Visible status";
	Lang[? "STATUS_TIP"] = "Changes are applied immediately.";
	Lang[? "PRESERVE"] = "Preserve elapsed time";
	Lang[? "PRESERVE_TIP"] = "It won't be reseted when changing titles.";
	Lang[? "REFRESH"] = "Refresh database";
	Lang[? "REFRESH_TIP"] = "It is automatically refreshed every day.";
	Lang[? "PAGE"] = "Official page";
	Lang[? "NEXT"] = "Next";
	Lang[? "UPDATE_STATUS"] = "Update status";
	Lang[? "UPDATE_INVISIBLE"] = "Your status is invisible";
	Lang[? "UPDATE_DISCONNECT"] = "You are disconnnected";

	Lang[? "CONSOLE"] = "Game console";
	Lang[? "REGION"] = "Preferred region";

	Lang[? "FRIEND_CODE"] = "Friend Code";
	Lang[? "NINTENDO_ID"] = "Nintendo Network ID";
	Lang[? "ABOUT"] = "Quick search link";
	Lang[? "ABOUT_TIP"] = "Displays a button on your status.";
	Lang[? "ELAPSED_TIME"] = "Elapsed time";

	Lang[? "SEARCH_TITLE"] = "Search title";
	Lang[? "CUSTOM_NAME"] = "Custom name";
	Lang[? "DESCRIPTION"] = "Description";
	
	Lang[? "RECENT"] = "Recent titles";
	Lang[? "RESULTS"] = "Matching results";
	Lang[? "NO_RESULTS"] = "No results";
	Lang[? "DEFAULT_TITLE"] = "Use custom name";
	
	Lang[? "WIIU"] = "Wii U";
	Lang[? "NINTENDO_SWITCH"] = "Nintendo Switch";
	Lang[? "NINTENDO_3DS"] = "Nintendo 3DS";
	
	Lang[? "AMERICA"] = "America";
	Lang[? "EUROPE"] = "Europe";
	Lang[? "JAPAN"] = "Japan";
	
	Lang[? "ABOUT_TITLE"] = "Search on";
	Lang[? "ABOUT_INTERNET"] = "Search on the internet";
	
	break;
}

#endregion
#region Functions

/// @function dBTN_Tooltip(x, y, content)
dBTN_Tooltip = function(x, y, content){
	
	gml_pragma("forceinline");
	
	draw_set_colour($bdbab8);
	draw_text_transformed(x, y-4, content, .5625, .5625, 0);
	draw_set_colour($FFFFFF);
}

/// @function dBTN_Reponsive(hover, color, x, y, content)
dBTN_Reponsive = function(hover, color, x, y, content){
	
	gml_pragma("forceinline");
	
	draw_sprite(gBTN_Responsive, color, x, y);
	if(hover)
		draw_sprite_ext(gBTN_Responsive, 1, x, y, 1, 1, 0, c_white, .15);
		
	draw_set_halign(fa_middle);
	draw_text_transformed(x+224, y+8, content, .875, .875, 0);
	draw_set_halign(fa_left);
}

/// @function dBTN_Switch(bool, x, y, content, tooltip)
dBTN_Switch = function(bool, x, y, content, tooltip){
	
	gml_pragma("forceinline");
	
	draw_sprite(gBTN_Switch, 17 * bool, x+368, y);
	var _Y = y;
	if(tooltip != ""){
		
		draw_set_colour($bdbab8);
		draw_text_transformed(x, _Y+30, tooltip, .5625, .5625, 0);
		draw_set_colour($FFFFFF);
	}
	else
		_Y += 12;
	draw_text_transformed(x, _Y-4, content, .875, .875, 0);
}

/// @function dBTN_Input(hover, search, x, y, content, tooltip)
dBTN_Input = function(typing, search, x, y, content, tooltip){

	gml_pragma("forceinline");
	
	draw_set_font(gFontGlyphs);
	
	var _Width = string_width(content); //* .75;
	var _Length = string_length(content);
	
	draw_sprite(gBTN_Input, search * (_Width < 380), x, y);

	if(content == ""){
		
		draw_set_font(gFontUI);
		draw_set_colour($7d7672);
		draw_text_transformed(x+14, y+9, tooltip, .75, .75, 0);
		draw_set_colour($FFFFFF);
		draw_set_font(gFontGlyphs);
	}
	
	var _X = 0;
	var _Text = content;

	if(typing){

		if(_Length == 0)
			_X = 6;
			
		if(_Width > 424){
		
			// Clamp text (right to left)
			for(var _C = _Length; _C > 0; --_C){
				
				var _W = string_width(string_copy(content, _C, _Length)); //* .75;
				if(_W >= 424)
					break;
			}			
			_Text = "..."+string_copy(content, _C+3, _Length)+Texts_Hint;
		}
		else	
			_Text = content+Texts_Hint;
	}
	else{
	
		if(_Width > 424){
		
			// Clamp text (left to right)
			for(var _C = 0; _C < _Length; ++_C){
				
				var _W = string_width(string_copy(content, 1, _C)); //* .75;
				if(_W >= 424)
					break;
			}			
			_Text = string_copy(content, 1, _C-3)+"...";
		}
	}
	
	draw_text_transformed(x + (14-_X), y+8, _Text, 1, 1, 0);
	draw_set_font(gFontUI);
}

/// @function dBTN_Drop(hover, x, y, content)
dBTN_Drop = function(hover, x, y, content){
	
	gml_pragma("forceinline");
	
	draw_sprite(gBTN_Drop, 0, x, y);
	if(hover)
		draw_sprite_ext(gBTN_Drop, 1, x, y, 1, 1, 0, c_white, .15);
	draw_text_transformed(x+14, y+10, content, .75, .75, 0);
}

/// @function dBTN_DropList(x, y, array, hover_index)
dBTN_DropList = function(x, y, text_array, hover_index){
	
	gml_pragma("forceinline");
	
	var _Length = array_length(text_array);
	draw_sprite_stretched(gBTN_DropList, 0, x-1, y-1, 450, 50 * (_Length+1));
	
	for(var _I = 0; _I < _Length; ++_I) {
		
		var _Y = 50 * (_I+1);
		
		if(hover_index == _I)
			draw_sprite(gBTN_DropList, 1, x-1, (y-1) + _Y);
	
		draw_text_transformed(x+14, y+10 + _Y, text_array[_I], .75, .75, 0);
	}
}

/// @function dFormatFC(platform, fc)
dFormatFC = function(platform, fc){
		
	gml_pragma("forceinline");
	
	var _fc = "";
	if(platform != ePLATFORM.WiiU){

		var _digits = string_digits(fc);
		
		// 3DS / Switch
		var _fc_convert = "____-____-____";
		for(var _d = 0; _d < 12+2; _d++){
	
			if(_d < string_length(_digits))
			&&(_digits != "")
				_fc_convert = string_replace(_fc_convert, "_", string_char_at(_digits, _d+1));
			else
				break;
		}
	
		// SW - ...
		if(platform == ePLATFORM.NintendoSwitch)
			_fc = "SW-"+_fc_convert;
		else
			_fc = _fc_convert;
	}
	else
		_fc = string_copy(fc, 1, 16);
	
	return _fc;
}

/// @function dUserData(save, settings, platform, title)
dUserData = function(save, settings, platform, title){
	
	gml_pragma("forceinline");
	
	ini_open(game_save_id+"preferences.cfg");
	if(save){
		
		ini_write_real("Application", "Version", version_int);
		
		if(settings){
			
			ini_write_real("Application", "WindowSize", Setting.WindowSize);
			ini_write_real("Application", "WindowX", window_get_x());
			ini_write_real("Application", "WindowY", window_get_y());
			ini_write_real("Application", "ScreenNumber", Setting.ScreenNumber);
			ini_write_real("Application", "DisplayStatus", Setting.DisplayStatus);
			ini_write_real("Application", "PreserveTime", Setting.PreserveTime);
			ini_write_real("Application", "Console", Platform.Console);
			ini_write_real("Application", "Link", Details.About);
			ini_write_real("Application", "ElapsedTime", Details.ElapsedTime);
			ini_write_string("Application", "LastRefresh", string(current_year)+string(current_month)+string(current_day));
			ini_write_real("Application", "Support", Page);
		}
		if(platform){
			
			var _Section = "Platform"+string(Platform.Console);
			
			ini_write_real(_Section, "Region", Platform.Region);
			ini_write_string(_Section, "FC", Details.FriendCode);
			
			for(var _H = 0; _H < array_length(History); ++_H){
			
				ini_write_string(_Section, "H"+string(_H)+"_Index", History[_H].Icon);
				ini_write_string(_Section, "H"+string(_H)+"_Client", History[_H].Client);
				ini_write_string(_Section, "H"+string(_H)+"_Name", History[_H].Name);
				ini_write_real(_Section, "H"+string(_H)+"Region", History[_H].Region);
			}
			
			ini_write_string(_Section, "Index", Title.Icon);
			ini_write_string(_Section, "Client", Title.Client);
			ini_write_string(_Section, "Name", Title.Name);
			ini_write_real(_Section, "Region", Title.Region);
		}		
		if(title){
			
			var _Section = "Platform"+string(Platform.Console);
			var _Key = string(md5_string_unicode(Title.Name));
			
			ini_write_string(_Section, _Key+"CNM", Title.CustomName);
			ini_write_string(_Section, _Key+"DSC", Title.Description);
		}
	}
	else{
		
		if(settings){
			
			Setting.WindowSize = ini_read_real("Application", "WindowSize", 1);
			Setting.WindowX = ini_read_real("Application", "WindowX", window_get_x());
			Setting.WindowY = ini_read_real("Application", "WindowY", window_get_y());
			Setting.ScreenNumber = ini_read_real("Application", "ScreenNumber", 0);
			Setting.DisplayStatus = ini_read_real("Application", "DisplayStatus", true);
			Setting.PreserveTime = ini_read_real("Application", "PreserveTime", false);
			Platform.Console = ini_read_real("Application", "Console", 0);
			Details.About = ini_read_real("Application", "Link", false);
			Details.ElapsedTime = ini_read_real("Application", "ElapsedTime", true);
			Setting.LastRefresh = ini_read_string("Application", "LastRefresh", "");
			Page = ini_read_real("Application", "Page", ePAGE.Platform);
		}
		if(platform){
			
			var _Section = "Platform"+string(Platform.Console);
			
			Platform.Region = ini_read_real(_Section, "Region", 0);
			Details.FriendCode = ini_read_string(_Section, "FC", "");
			Title.Name = ini_read_string(_Section, "Title", -1);
			
			for(var _H = 0; _H < array_length(History); ++_H){
			
				History[_H].Icon = ini_read_string(_Section, "H"+string(_H)+"_Index", "");
				History[_H].Client = ini_read_string(_Section, "H"+string(_H)+"_Client", "0");
				History[_H].Name = ini_read_string(_Section, "H"+string(_H)+"_Name", "");
				History[_H].Region = ini_read_real(_Section, "H"+string(_H)+"_Region", 0);
			}

			Title.Icon = ini_read_string(_Section, "Index", "");
			Title.Client = ini_read_string(_Section, "Client", "0");
			Title.Name = ini_read_string(_Section, "Name", "");
			Title.Region = ini_read_real(_Section, "Region", 0);

			if(string_length(Details.FriendCode) > 0)
				Texts_FriendCode = dFormatFC(Platform.Console, Details.FriendCode);	
			else
				Texts_FriendCode = "";
		}		
		if(title){
			
			var _Section = "Platform"+string(Platform.Console);
			var _Key = string(md5_string_unicode(Title.Name));
			
			Title.CustomName = ini_read_string(_Section, _Key+"CNM", "");
			Title.Description = ini_read_string(_Section, _Key+"DSC", "");
		}
	}
	ini_close();
}

/// @function dTitlesSheet(platform)
dTitlesSheet = function(platform){
				
	gml_pragma("forceinline");
	
	var _CSV = "";
	switch(Platform.Console){
				
		case(ePLATFORM.WiiU):			_CSV = "titles_wiiu.csv";		break;
		case(ePLATFORM.NintendoSwitch):	_CSV = "titles_nswitch.csv";	break;
		case(ePLATFORM.Nintendo3DS):	_CSV = "titles_n3ds.csv";		break;
	}
	
	if(file_exists(game_save_id+_CSV))
		return load_csv(_CSV);
	else
		return ds_grid_create(1, 1);
}

/// @function dClientID(platform, index)
dClientID = function(platform, index){

	gml_pragma("forceinline");
	
	var _ID = "";
	var _CFG = "";
	switch(platform){
				
		case(ePLATFORM.WiiU):			_CFG = "client_wiiu.cfg";		break;
		case(ePLATFORM.NintendoSwitch):	_CFG = "client_nswitch.cfg";	break;
		case(ePLATFORM.Nintendo3DS):	_CFG = "client_n3ds.cfg";		break;
	}
	if(_CFG != ""){
			
		ini_open(game_save_id+_CFG);
		_ID = ini_read_string("application_id", index, "");
		ini_close();
	}
	return _ID;
}

/// @function dURLEncond(url)
dURLEncond = function(url){

	// YellowAfterlife's script
	
	gml_pragma("global", "global._url_encode_ready = false;");
	var l_inbuf, l_outbuf, l_allowed, l_hex, l_ind;
	if(global._url_encode_ready){
		
	    l_inbuf = global._url_encode_in;
	    l_outbuf = global._url_encode_out;
	    l_allowed = global._url_encode_allowed;
	    l_hex = global._url_encode_hex;
	}
	else{
		
	    global._url_encode_ready = true;
	    
		l_inbuf = buffer_create(1024, buffer_grow, 1);
	    
		global._url_encode_in = l_inbuf;
	    
		l_outbuf = buffer_create(1024, buffer_grow, 1);
		
	    global._url_encode_out = l_outbuf;
	    
		l_allowed = array_create(256);
	    
		for (l_ind = ord("A"); l_ind <= ord("Z"); l_ind++) l_allowed[l_ind] = true;
	    for (l_ind = ord("a"); l_ind <= ord("z"); l_ind++) l_allowed[l_ind] = true;
	    for (l_ind = ord("0"); l_ind <= ord("9"); l_ind++) l_allowed[l_ind] = true;
	    
		l_allowed[ord("-")] = true;
	    l_allowed[ord("_")] = true;
	    l_allowed[ord(".")] = true;
	    l_allowed[ord("!")] = true;
	    l_allowed[ord("~")] = true;
	    l_allowed[ord("*")] = true;
	    l_allowed[ord("'")] = true;
	    l_allowed[ord("(")] = true;
	    l_allowed[ord(")")] = true;
		
	    global._url_encode_allowed = l_allowed;

	    l_hex = array_create(256);
	    for(l_ind = 0; l_ind < 256; l_ind++){
			
	        var l_hv, l_hd = l_ind >> 4;
			
	        if(l_hd >= 10)
	            l_hv = ord("A") + l_hd - 10;
			else
				l_hv = ord("0") + l_hd;
			
	        l_hd = l_ind & $F;
		
	        if(l_hd >= 10)
	            l_hv |= (ord("A") + l_hd - 10) << 8;
	        else
				l_hv |= (ord("0") + l_hd) << 8;
		
	        l_hex[l_ind] = l_hv;
	    }
	    global._url_encode_hex = l_hex;
	}
	
	buffer_seek(l_inbuf, buffer_seek_start, 0);
	buffer_write(l_inbuf, buffer_text, url);
	var l_len = buffer_tell(l_inbuf);
	
	buffer_seek(l_inbuf, buffer_seek_start, 0);
	buffer_seek(l_outbuf, buffer_seek_start, 0);
	repeat(l_len){
		
	    var l_byte = buffer_read(l_inbuf, buffer_u8);
	    if(l_allowed[l_byte])
	        buffer_write(l_outbuf, buffer_u8, l_byte);
		else{
			
	        buffer_write(l_outbuf, buffer_u8, ord("%"));
	        buffer_write(l_outbuf, buffer_u16, l_hex[l_byte]);
	    }
	}
	
	buffer_write(l_outbuf, buffer_u8, 0);
	buffer_seek(l_outbuf, buffer_seek_start, 0);
	return buffer_read(l_outbuf, buffer_string);
}

#endregion
#region Preferences
	
// Settings
Setting = {
	
	WindowSize : 0,
	WindowX : window_get_x(),
	WindowY : window_get_y(),
	ScreenNumber : 1,
	DisplayStatus : true,
	PreserveTime : false,
	LastRefresh : string(current_year)+string(current_month)+string(current_day),
}

// Platform
Platform = {

	Console : 0,
	Region : 0,
}

// Details
Details = {

	FriendCode : "",
	About : false,
	ElapsedTime : false,
	Timestamp : 0,
}

// Title
Title = {
	
	Icon : "_default",
	Client : "0",
	Name : "",
	Region : 0,
	
	CustomName : "",
	Description : "",
}

// Recent titles
for(var _H = 0; _H < 4; ++_H){
	
	History[_H] = {

		Icon : "_default",
		Client : "0",
		Name : "",
		Region : 0,
	}
}

#endregion
#region Interface

Standby = 0;
Link_Page = "";
Boot_Animation = 0;

// Download list
Download = "";
Download_List = [];
Download_Index = -1;
Download_BlockApp = false;

// Cursor
Cursor_X = -16;
Cursor_Y = -16;

// Database
Refresh = 0;
Refresh_Animation = 0;
Refresh_Spinning = 0;

// App update
AppUpdate = false;
AppUpdate_Link = "";
AppUpdate_Mandatory = false;

// User
State_Avatar = noone;
State_Name = "";
State_Status = Lang[? "CONNECTING"]+"...";
State_Connected = false;
State_GotProfileData = false;
State_Playing = false;

// Window
Window_Move = false;
Window_PivotX = 0;
Window_PivotY = 0;

// Buttons
Button[eBUTTON.Close] = { X : 512-56, }
Button[eBUTTON.Expand] = { X : 512-112, }
Button[eBUTTON.Suspend] = { X : 512-168, }
Button[eBUTTON.Restart] = { X : 16, }
Button[eBUTTON.Update] = { X : 512-128, Tip : Lang[? "UPDATE_APP"], }
Button[eBUTTON.Settings] = { X : 512-64, Tip : Lang[? "SETTINGS"], }
Button[eBUTTON.Platform] = { X : 32, Tip : Lang[? "PLATFORM"], }
Button[eBUTTON.Details] = { X : 186, Tip : Lang[? "DETAILS"], }
Button[eBUTTON.Title] = { X : 340, Tip : Lang[? "TITLE"], }
Button[eBUTTON.Status] = { Y : 160, Anim : 0, }
Button[eBUTTON.PreserveTime] = { Y : 232, Anim : 0,}
Button[eBUTTON.Refresh] = { Y : 312, }
Button[eBUTTON.Console] = { Y : 255, }
Button[eBUTTON.Region] = { Y : 351, }
Button[eBUTTON.FriendCode] = { Y : 232, }
Button[eBUTTON.About] = { Y : 294, Anim : 0, }
Button[eBUTTON.ElapsedTime] = { Y : 359, Anim : 0, }
Button[eBUTTON.TitleSearch] = { Y : 232, }
Button[eBUTTON.CustomName] = { Y : 295, }
Button[eBUTTON.Description] = { Y : 360, }
Hover = eBUTTON.None;

// Pages
Page = ePAGE.Platform;
Page_Current = -1;
Page_Reminder = Page;
Page_S = 0;
Page_E = 0;

for(var _A = 0; _A < ePAGE.Settings+1; ++_A)
	Page_Animation[_A] = 0;

// Type
Type = eTYPE.None;

// Tooltips
Tooltip_Animation = 0;
Tooltip_Display = false;
Tooltip_Horizontal = false;
Tooltip_Content = "";
Tooltip_X = 0;
Tooltip_Y = 0;

// Context menu
Context_Display = false;
Context_Hover = -1;
Context_Items = [ Lang[? "CUT"], Lang[? "COPY"], Lang[? "PASTE"] ];
Context_X = 0;
Context_Y = 0;

// Predefined texts
Texts_Console = [ Lang[? "WIIU"], Lang[? "NINTENDO_SWITCH"], Lang[? "NINTENDO_3DS"] ];
Texts_Region = [ Lang[? "AMERICA"], Lang[? "EUROPE"], Lang[? "JAPAN"] ];
Texts_Hint = "|";
Texts_FriendCode = "";

// Search
Search_Animation = 0;
Search_Animation_Button = 0;
Search_Title = "";
Search_Hover = -1;
Search_Cooldown = 0;

Search_List_Icon = [];
Search_List_Client = [];
Search_List_Name = [];
Search_List_Region = [];

// Drop list
DropList_Hover = -1;

#endregion

// Load
dUserData(false, true, true ,true);

// Download database
var _DatabaseFile = "";
var _DatabaseInit = file_text_open_read(included_files+"database.ini");
if(_DatabaseInit != -1){
	
	_DatabaseFile = file_text_read_string(_DatabaseInit);
	file_text_close(_DatabaseInit);
}

if(Setting.LastRefresh != string(current_year)+string(current_month)+string(current_day)){

	if(string_pos("://", _DatabaseFile) > 0){

		Download_Index = 0;
		Download = http_get_file(_DatabaseFile, game_save_id+"database.cfg");
		Download_BlockApp = true;
	}
	else{
		
		file_copy(_DatabaseFile, game_save_id+"database.cfg");
		event_user(1);
		
		if(array_length(Download_List) > 0)
			Download_BlockApp = true;
	}
}
else	
	event_user(2);
	
// Titles
Spreadsheet = -1;

// Client
Client_CurrentID = dClientID(Platform.Console, Title.Client);
Client_RunningID = "";
Client_StatusConsole = Platform.Console;
Client_StatusName = Title.Name;
	
// Initializate RPC
if(!Download_BlockApp){
	
	np_initdiscord(Client_CurrentID, true, np_steam_app_id_empty);
	Client_RunningID = Client_CurrentID;
}
else
	Boot_Animation = 1;
	
// Window
WindowBuffer = surface_create(512, 512);
WindowWH = 256 + (128 * Setting.WindowSize);

// Check screen count
var _Screens = window_get_visible_rects(0, 0, 0, 0);
if(Setting.ScreenNumber == array_length(_Screens) / 8)
	window_set_position(Setting.WindowX, Setting.WindowY);

window_set_size(WindowWH, WindowWH);