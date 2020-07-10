/// @param platform
/// @param fc

var _fc = "";
if(argument0 != ePlatform.WiiU){

	// 3DS / Switch
	var _fc_convert = "____-____-____";
	for(var _d = 0; _d < 12+2; _d++){
	
		if(_d < string_length(argument1))
		&&(argument1 != "")
			_fc_convert = string_replace(_fc_convert, "_", string_char_at(argument1, _d+1));
		else
			break;
	}
	
	// SW - ...
	if(argument0 == ePlatform.NintendoSwitch)
		_fc = "SW-"+_fc_convert;
	else
		_fc = _fc_convert;
}
else
	_fc = argument1;

return _fc;