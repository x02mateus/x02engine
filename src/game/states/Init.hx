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
		- Suporte nativo a controles Mobile (Mobile)
		- Charts em BIN para melhor otimização
		- Code compacto e limpo
		- Poder jogar a música que quiser (sugestão feita pela Maria Clara)
		- Ter uma gameplay confortável e agradável para o usuário, com bastantes opções de customização

	ESSE ARQUIVO É TEMPORÁRIO, E É USADO APENAS PARA AS CONFIGURAÇÕES INICIAIS DA ENGINE (SaveData, Input, etc.)
 */
 package game.states;

import flixel.effects.FlxFlicker;

class Init extends MusicBeatState
{
	var texto:FlxText;
	var coiso:String;

	override function create()
	{
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		SaveData.init();

		if (SaveData.firstTime) {
			initialConfigs();
			coiso = #if desktop '${LanguageManager.getString('press', 'Common')} ENTER' #elseif mobile LanguageManager.getString('touch', 'Common') #end;
			displayText();
		} else
			MusicBeatState.switchState(new MainMenuState());
	
		super.create();
	}

	override function update(elapsed:Float)
	{
		var justPressed:Bool = #if desktop FlxG.keys.justPressed.ENTER #elseif mobile BSLTouchUtils.justTouched() #end;
		if (justPressed)
			changeState();

		super.update(elapsed);
	}
	
	private function initialConfigs() {
		backend.PresetsManager.checkandset();
	}

	private function displayText()
	{
		texto = new FlxText(0, 0, LanguageManager.getString('initText', 'Misc'));
		texto.text.replace('<coiso>', coiso);
		texto.scrollFactor.set();
		texto.setFormat(Paths.font('akira.otf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		texto.screenCenter(XY);
		texto.moves = false;
		texto.antialiasing = false;
		add(texto);
	}

	private function changeState()
	{
		GlobalSoundManager.play(confirmMenu);
		SaveData.firstTime = false;
		SaveData.save();
		FlxFlicker.flicker(texto, 1, 0.1, false, true, function(flk:FlxFlicker)
		{
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				// Agora os presets são automáticos, então decidi deixar a troca deles só no options
				MusicBeatState.switchState(new MainMenuState());
			});
		});
	}
}