/// @description Shutdown

// Unload translations
if(ds_exists(global.OutputMessage, ds_type_map))
	ds_map_destroy(global.OutputMessage);