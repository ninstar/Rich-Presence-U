#macro Version 54
#macro VersionString "0.5.4"
#macro SaveDir game_save_id

#region Traduções

switch(os_get_language()){
	
	case("pt"):

	// [PT] Português
	global.DLG_FIELD_Title = "Título";
	global.DLG_FIELD_Details = "Detalhes";
	global.DLG_FIELD_FriendCode = "Friend Code";
	global.DLG_FIELD_ElapsedTime = "Tempo Decorrido";
	global.DLG_FIELD_UpdateNotification = "Atualização Disponível";

	global.DLG_TIP_Title = "Continue digitando para encontrar um título.";
	global.DLG_TIP_Details = "Digite seu status personalizado aqui.";
	global.DLG_TIP_DetailsTitle = "Digite seu título personalizado aqui.";
	global.DLG_TIP_FriendCode = "Digite sua identificação aqui.";

	global.DLG_CustomTitle = "Título Personalizado";
	global.DLG_UseDetails = "Use a barra de detalhes.";

	global.DLG_About = "Clique no logotipo para obter mais informações.";
	global.DLG_Connection = "Você deve estar conectado à Internet para usar este aplicativo.";
	global.DLG_Update = "Uma nova atualização está disponível, ela necessária para que o aplicativo continue funcionando. Você será redirecionado para a página de download ao pressionar 'Sim'.";
	global.DLG_ClientError = "O client não está disponível, feche o aplicativo e tente novamente mais tarde.";

	break;
	case("es"):

	// [ES] Español
	global.DLG_FIELD_Title = "Título";
	global.DLG_FIELD_Details = "Detalles";
	global.DLG_FIELD_FriendCode = "Friend Code";
	global.DLG_FIELD_ElapsedTime = "Tiempo Transcurrido";
	global.DLG_FIELD_UpdateNotification = "Actualización Disponible";

	global.DLG_TIP_Title = "Continúe ingresando para encontrar un título.";
	global.DLG_TIP_Details = "Ingrese su estado personalizado aquí.";
	global.DLG_TIP_DetailsTitle = "Ingrese su título personalizado aquí.";
	global.DLG_TIP_FriendCode = "Ingrese su identificación aquí.";

	global.DLG_CustomTitle = "Título Personalizado";
	global.DLG_UseDetails = "Utiliza la barra de detalles.";

	global.DLG_About = "Oprima en el logo para más información.";
	global.DLG_Connection = "Debe estar conectado al internet para utilizar esta aplicación.";
	global.DLG_Update =  "Una actualización nueva esta disponible, esta actualización es necesaria para que la aplicación continúe funcionando. Al oprimir 'Si' usted será redirigido a la página de descarga.";
	global.DLG_ClientError = "El cliente no está disponible, cierra la aplicación e intente nuevamente más tarde.";

	break;
	defautl:

	// [??] English
	global.DLG_FIELD_Title = "Title";
	global.DLG_FIELD_Details = "Details";
	global.DLG_FIELD_FriendCode = "Friend Code";
	global.DLG_FIELD_ElapsedTime = "Elapsed Time";
	global.DLG_FIELD_UpdateNotification = "Update Available";

	global.DLG_TIP_Title = "Keep typing to find a title.";
	global.DLG_TIP_Details = "Type your custom status here.";
	global.DLG_TIP_DetailsTitle = "Your custom title here.";
	global.DLG_TIP_FriendCode = "Type your ID here.";

	global.DLG_CustomTitle = "Custom Title";
	global.DLG_UseDetails = "Use the details bar.";

	global.DLG_About = "Click on the logo for more information.";
	global.DLG_Connection = "You must be connected to the internet in order to use this application.";
	global.DLG_Update = "A new update is available, this update is necessary for the application to continue working. By pressing 'Yes' you will be redirected to the download page.";
	global.DLG_ClientError = "The client is not available, close the application and try again later.";

	break;
}

#endregion

enum ePlatform {

	WiiU,				// 0
	NintendoSwitch,		// 1
	Nintendo3DS			// 2
}

enum eDetails {

	Single,				// 0
	Multi,				// 1
	Custom				// 2
}