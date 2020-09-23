/// @description Interface
gpu_set_tex_filter(true);

#region Presets

// GUI
display_set_gui_size(window_get_width(), window_get_height());
var _W = display_get_gui_width();
var _H = display_get_gui_height();

// Alpha
if(instance_exists(oProgram)){

	if(GUI_Alpha > 0)
		GUI_Alpha -= 0.05;
	else
		instance_destroy(id, true);
}

// Colors
var _cBGR = merge_color($36312f, $f2f3f5, !global.GUI_Theme);
var _cTXT = merge_color($36312f, $f2f3f5, global.GUI_Theme);

#endregion

// Background
draw_sprite_stretched_ext(sBackground, 0, -24, -24, _W+24, _H+24, _cBGR, GUI_Alpha);

// Boot animation
GUI_Boot_Anim -= 6;
draw_sprite_ext(sBoot, 0, _W/2, _H/2, 1, 1, 0, _cTXT,  GUI_Alpha);
draw_sprite_ext(sBoot, 1, _W/2, _H/2, 1, 1, GUI_Boot_Anim, _cTXT, GUI_Alpha);

gpu_set_tex_filter(false);