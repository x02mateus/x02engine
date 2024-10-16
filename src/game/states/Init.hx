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