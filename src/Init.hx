/* 
	Bom, a ideia pra essa "engine" é, trazer as coisas do FNF e ao mesmo tempo modificá-las de forma que me agradem.
	A principal ideia é fazer ser um jogo confortável, leve e sem lag ao mesmo tempo.
	Andei pensando em coisas como:
		- Suporte a charts de CH, Osu!, FNF (junto de conversores de charts de outros jogos)
		- Suporte a backgrounds com vídeo, tanto customizados, como backgrounds padrões das charts
		- Suporte a charts/skins customizadas sem ter que recompilar o jogo
		- Suporte a customização dos menus de forma softcoded (utilizando JSONs para determinar visibilidade, posição de sprites e etc)
		- Suporte nativo a gamepad (Mobile/Desktop)
		- Suporte nativo a teclado (Mobile/Desktop)
		- Suporte nativo a touch/mouse (Mobile/Desktop)
		- Suporte nativo a controles Mobile (Mobile)
		- Charts em BIN para melhor otimização
		- Code compacto e limpo

	ESSE ARQUIVO É TEMPORÁRIO, E É USADO APENAS PARA AS CONFIGURAÇÕES INICIAIS DA ENGINE (SaveData, Input, etc.)
 */
 
 import flixel.FlxState;
 
 class Init extends FlxState {
	override function create() {
		SaveData.init();
		super.create();
	}
 }