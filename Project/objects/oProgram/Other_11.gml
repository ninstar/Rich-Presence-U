/// @description Download list
ini_open(game_save_id+"database.cfg");

var _Titles_WIIU = ini_read_string("titles", "wiiu", "");
var _Titles_NSWITCH = ini_read_string("titles", "nswitch", "");
var _Titles_N3DS = ini_read_string("titles", "n3ds", "");
var _Client_WIIU = ini_read_string("client", "wiiu", "");
var _Client_NSWITCH = ini_read_string("client", "nswitch", "");
var _Client_N3DS = ini_read_string("client", "n3ds", "");

ini_close();

var _L = -1;
if(string_pos("://", _Titles_WIIU) > 0){	_L++;	Download_List[_L] = [_Titles_WIIU, game_save_id+"titles_wiiu.csv"];			}else	file_copy(_Titles_WIIU, game_save_id+"titles_wiiu.csv");
if(string_pos("://", _Titles_NSWITCH) > 0){ _L++;	Download_List[_L] = [_Titles_NSWITCH, game_save_id+"titles_nswitch.csv"];	}else	file_copy(_Titles_NSWITCH, game_save_id+"titles_nswitch.csv");
if(string_pos("://", _Titles_N3DS) > 0){	_L++;	Download_List[_L] = [_Titles_N3DS, game_save_id+"titles_n3ds.csv"];			}else	file_copy(_Titles_N3DS, game_save_id+"titles_n3ds.csv");
if(string_pos("://", _Client_WIIU) > 0){	_L++;	Download_List[_L] = [_Client_WIIU, game_save_id+"client_wiiu.cfg"];			}else	file_copy(_Client_WIIU, game_save_id+"client_wiiu.cfg");
if(string_pos("://", _Client_NSWITCH) > 0){ _L++;	Download_List[_L] = [_Client_NSWITCH, game_save_id+"client_nswitch.cfg"];	}else	file_copy(_Client_NSWITCH, game_save_id+"client_nswitch.cfg");
if(string_pos("://", _Client_N3DS) > 0){	_L++;	Download_List[_L] = [_Client_N3DS, game_save_id+"client_n3ds.cfg"];			}else	file_copy(_Client_N3DS, game_save_id+"client_n3ds.cfg");

if(_L > -1){

	Download_Index = 0;
	var _DL = Download_List[Download_Index];
	Download = http_get_file(_DL[0], _DL[1]);
}
else{
	
	Client_CurrentID = dClientID(Platform.Console, Title.Client);
		
	// Initializate RPC
	if(Download_BlockApp){
		
		np_initdiscord(Client_CurrentID, true, np_steam_app_id_empty);
		Client_RunningID = Client_CurrentID;
	}
	
	Download_BlockApp = false;
	Download_Index = -1;
}