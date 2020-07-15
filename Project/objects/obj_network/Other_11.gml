/// @description Iniciar Rich Presence U

//Atualização obrigatória
if(global.NET_Update_Version > Version)
&&(global.NET_Update_Mandatory){

	var _GetUpdate = show_question(global.DLG_Update);
	if(_GetUpdate == 1)
		url_open(global.NET_Update_Download);
	game_end();
}
else{

	instance_create_depth(0, 0, 0, obj_Program);
	instance_destroy(id, true);
}