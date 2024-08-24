package game.states;

import flixel.util.FlxAxes;

using StringTools;

class PresetsState extends MusicBeatState
{
	private var keyTextDisplay:FlxText;
	private var curSelected:Int = 0;
	private var judgementText:Array<String>;
	private var explicacoes:Array<String>;
	private var blackBox:FlxSprite;
	private var infoText:FlxText;
	private var acceptInput:Bool = false;
	public static var options:Bool = false;

	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		add(createBackground());

		judgementText = ["Gama Alta (4GB+)", "Gama Media(3GB+)", "Gama Baja(2GB+)", "Voltar", ''];
		explicacoes = [
			"Tudo do jogo estara ativado (recomendado para acima de 4 GB de RAM)",
			"A notificacao de acerto nao estara visivel e vai estabilizar o FPS (recomendado para 3 GB de RAM)",
			"Removera detalhes consideraveis do jogo, mas voce ainda podera jogar normalmente (recomendado para 2 GB de RAM)",
			"Voce nao estara escolhendo nenhum preset. Clique novamente para voltar ao menu.",
			''
		];

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
		txt.setFormat(Paths.font("akira.otf"), 21, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
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
		infoText.text = 'Escolha um Preset de otimizacao\n\n${judgementText[curSelected]}:\n${explicacoes[curSelected]}';
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

	private function selecionarPreset()
	{
		GlobalSoundManager.play(confirmMenu);
		switch (curSelected)
		{
			case 0:
				SaveData.gpu = true;
				SaveData.antialiasing = true;
				SaveData.fps = 90;
			case 1:
				SaveData.gpu = true;
				SaveData.antialiasing = false;
				SaveData.fps = 60;
			case 2:
				SaveData.gpu = false;
				SaveData.antialiasing = false;
				SaveData.fps = 30;
		}

		if (curSelected < 3)
			SaveData.curPreset = curSelected;

		SaveData.save();
		if(options) {
			options = false;
			MusicBeatState.switchState(new game.states.options.ConfiguracoesState());
		} else
			MusicBeatState.switchState(new MainMenuState());
	}

	private function quit()
	{
		CoolUtil.flash(1);
		FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0}, 1.1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween) { 
				if(options) {
					options = false;
					MusicBeatState.switchState(new game.states.options.ConfiguracoesState());
				} else
					MusicBeatState.switchState(new MainMenuState());
			}
		});
		FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
	}

	private function changeItem(_amount:Int = 0)
	{
		curSelected = (curSelected + _amount + 4) % 4;
	}
}