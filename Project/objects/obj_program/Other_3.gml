/// @description Fechar Rich Presence U

// Desligar RPC
discord_presence_shutdown();

// Salvar definições
scr_UserConfig(true, true);

// Deletar cache de icones
if(directory_exists(SaveDir+"cache\\"))
	directory_destroy(SaveDir+"cache\\");