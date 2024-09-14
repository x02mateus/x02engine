package game.states.options;

import flixel.util.FlxAxes;

using StringTools;

class LanguagesState extends MusicBeatState
{
	private var keyTextDisplay:FlxText;
	private var curSelected:Int = 0;
	private var judgementText:Array<String>;
	private var blackBox:FlxSprite;
	private var infoText:FlxText;
	private var acceptInput:Bool = false;
	private var chooseText:String = '';
	public static var options:Bool = false;

	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		updateStrings();
		Main.mouse_allowed = false;

		add(createBackground());

		blackBox = createBlackBox();
		add(blackBox);
		infoText = createInfoText();
		add(infoText);
		keyTextDisplay = createKeyTextDisplay();
		add(keyTextDisplay);

		FlxTween.tween(keyTextDisplay, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0.7}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween) acceptInput = true
		});
		
		textUpdate();

		#if mobileC
		addVirtualPad(UP_DOWN, A);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (acceptInput)
		{
			handleInput();
		}

		super.update(elapsed);
	}

	private function createBackground():FlxSprite
	{
		var bg = new FlxSprite().loadGraphic(Paths.image("backgrounds/1"));
		return bg;
	}

	private function createBlackBox():FlxSprite
	{
		var box = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		box.alpha = 0;
		return box;
	}

	private function createInfoText():FlxText
	{
		var txt = new FlxText(-10, 580, 1280, '', 72);
		txt.scrollFactor.set(0, 0);
		txt.setFormat(Paths.font("Persona4.ttf"), 21, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		txt.borderSize = 2;
		txt.borderQuality = 3;
		txt.alpha = 0;
		txt.screenCenter(FlxAxes.X);
		txt.antialiasing = SaveData.antialiasing;
		return txt;
	}

	private function createKeyTextDisplay():FlxText
	{
		var txt = new FlxText(-10, 0, 1280, "", 72);
		txt.scrollFactor.set(0, 0);
		txt.setFormat(Paths.font("akira.otf"), 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		txt.borderSize = 2;
		txt.borderQuality = 3;
		txt.moves = false;
		txt.antialiasing = SaveData.antialiasing;
		txt.alpha = 0;
		return txt;
	}

	private function handleInput()
	{
		if (controls.UP_P)
		{
			GlobalSoundManager.play(scrollMenu);
			changeItem(-1);
			updateJudgement();
		}

		if (controls.DOWN_P)
		{
			GlobalSoundManager.play(scrollMenu);
			changeItem(1);
			updateJudgement();
		}

		if (controls.ACCEPT)
			selecionarPreset();

		if (controls.BACK)
			quit();
	}

	private function updateJudgement()
	{

		infoText.text = '${chooseText}\n\n${judgementText[curSelected]}';
		textUpdate();
	}

	private function textUpdate()
	{
		keyTextDisplay.text = "\n\n";

		for (i in 0...judgementText.length - 1)
		{
			var textStart = (i == curSelected) ? "> " : "  ";
			keyTextDisplay.text += textStart + judgementText[i] + "\n";
		}

		keyTextDisplay.screenCenter();
	}

	private function updateStrings() {
		switch (SaveData.language)
		{
			case "pt-BR":
				judgementText = ["Português do Brasil", "Inglês (Estados Unidos)", "Espanhol (America Latina)", "Voltar", ''];
				chooseText = "Linguagem selecionada:";
				
			case "en-US":
				judgementText = ["Brazilian Portuguese", "English (USA)", "Spanish (Latin America)", "Back", ''];
				chooseText = "Selected language:";
				
			case "es-ES":
				judgementText = ["Portugués de Brasil", "Inglés (Estados Unidos)", "Español (America Latina)", "Volver", ''];
				chooseText = "Idioma seleccionado:";
		}
	}

	private function selecionarPreset()
	{
		GlobalSoundManager.play(confirmMenu);
		SaveData.save();
		backend.LanguageManager.checkandset(); // ZYEEEEEEEEEUEUUNNNNNNN
		MusicBeatState.switchState(new MainMenuState());
	}

	private function quit()
	{
		CoolUtil.flash(1);
		FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0}, 1.1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween) { 
				MusicBeatState.switchState(new game.states.options.AjustesState());
			}
		});
		FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
	}

	private function changeItem(_amount:Int = 0)
	{
		curSelected = (curSelected + _amount + 4) % 4;
		
		switch (curSelected) {
			case 0:		SaveData.language = "pt-BR";
			case 1:		SaveData.language = "en-US";
			case 2:		SaveData.language = "es-ES";		
		}

		updateStrings(); // Não queria repetir code aqui, e o jeito inteligente era só fazer uma função :thumbsup:
		updateJudgement();
		textUpdate();
	}
}