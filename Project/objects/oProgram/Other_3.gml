if(ds_exists(Spreadsheet, ds_type_map))
	ds_map_destroy(Lang);

if(ds_exists(Spreadsheet, ds_type_grid))
	ds_grid_destroy(Spreadsheet);

if(surface_exists(WindowBuffer))
	surface_free(WindowBuffer);

// Save screen count
var _Screens = window_get_visible_rects(0, 0, 0, 0);
Setting.ScreenCount = array_length(_Screens) / 8;

// Make sure to restore window before closing
window_command_run(window_command_restore);

// Save
dUserData(true, true, true, true);