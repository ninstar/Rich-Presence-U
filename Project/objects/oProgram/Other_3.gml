if(ds_exists(Spreadsheet, ds_type_map))
	ds_map_destroy(Lang);

if(ds_exists(Spreadsheet, ds_type_grid))
	ds_grid_destroy(Spreadsheet);

if(surface_exists(WindowBuffer))
	surface_free(WindowBuffer);

// Save
dUserData(true, true, true, true);