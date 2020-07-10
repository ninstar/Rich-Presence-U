/// @description Iniciar Rich Presence U

//Atualização obrigatória
if(global.NET_Update_Version > Version)
&&(global.NET_Update_Mandatory){

	var _GetUpdate = show_question("A new update is available, this update is necessary for the application to continue working. You will be redirected to the download page by pressing 'Yes'.");
	if(_GetUpdate == 1)
		url_open(global.NET_Update_Download);
	game_end();
}
else{

	instance_create_depth(0, 0, 0, obj_program);
	instance_destroy(id, true);
}