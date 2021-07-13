/// @description Download images
if(async_load[? "id"] == State_Avatar){
	
	if(async_load[? "status"] >= 0)
		State_Avatar = async_load[? "id"];
}