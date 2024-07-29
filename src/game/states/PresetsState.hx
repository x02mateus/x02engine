package game.states; // Ainda incompleto... Mas já são 4 da manhã e eu tô com sono...

import flixel.util.FlxAxes;

using StringTools;

class PresetsState extends MusicBeatState
{
	// Por algum motivo, quando tu sai do Init.hx pro Presets, se tu ficar trocando entre as opções, a memória chega até a 300~400mb :skull:
	var keyTextDisplay:FlxText;
	var curSelected:Int = 0;

	var judgementText:Array<String>;

	var explicacoes:Array<String>;

	var blackBox:FlxSprite;
	var infoText:FlxText;

	var acceptInput:Bool = false;

	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();
		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("backgrounds/1"));
		add(bg);

		judgementText = ["Gama Alta (4GB+)", "Gama Media(3GB+)", "Gama Baja(2GB+)", "Voltar", ''];
		explicacoes = [
			"Tudo do mod original estará ativado (recomendado para acima de 4 GB de RAM)",
			"A notificação de acerto não estará visível e irá estabilizar o FPS (recomendado para 3 GB de RAM)",
			"Removerá detalhes consideráveis do jogo, mas ainda poderá acompanhar a história principal (recomendado para 2 GB de RAM)",
			"Você não estará escolhendo nenhum preset. Clique novamente para voltar ao menu.",
			''
		];

		keyTextDisplay = new FlxText(-10, 0, 1280, "", 72);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat(Paths.font("akira.otf"), 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		keyTextDisplay.borderSize = 2;
		keyTextDisplay.borderQuality = 3;
		keyTextDisplay.moves = false;
		keyTextDisplay.antialiasing = SaveData.antialiasing;
		blackBox = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackBox);
		infoText = new FlxText(-10, 580, 1280, '', 72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat(Paths.font("akira.otf"), 21, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		infoText.borderSize = 2;
		infoText.borderQuality = 3;
		infoText.alpha = 0;
		infoText.screenCenter(FlxAxes.X);
		keyTextDisplay.moves = false;
		infoText.antialiasing = SaveData.antialiasing;
		add(infoText);
		add(keyTextDisplay);
		blackBox.alpha = 0;
		keyTextDisplay.alpha = 0;
		FlxTween.tween(keyTextDisplay, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0.7}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween)
			{
				acceptInput = true;
			}
		});
		textUpdate();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (acceptInput)
		{
			if (FlxG.keys.justPressed.UP)
			{
				GlobalSoundManager.play(scrollMenu);
				changeItem(-1);
				updateJudgement();
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				GlobalSoundManager.play(scrollMenu);
				changeItem(1);
				updateJudgement();
			}

			if (FlxG.keys.justPressed.ENTER)
				selecionarpreset();

			if (FlxG.keys.justPressed.BACKSPACE)
				quit();
		}

		super.update(elapsed);
	}

	function updateJudgement()
	{
		infoText.text = 'Escolha um Preset de otimização\n\n' + judgementText[curSelected] + ': ' + explicacoes[curSelected];

		textUpdate();
	}

	function textUpdate()
	{
		keyTextDisplay.text = "\n\n";

		for (i in 0...judgementText.length - 1)
		{
			var textStart = (i == curSelected) ? "> " : "  ";
			keyTextDisplay.text += textStart + judgementText[i] + "\n";
		}

		keyTextDisplay.screenCenter();

		infoText = new FlxText(-10, 580, 1280,
			'Escolha um Preset de otimização\nToque na opção duas vezes para confirmar\n\n'
			+ judgementText[curSelected]
			+ ': '
			+ explicacoes[curSelected], 72);
	}

	function selecionarpreset()
	{
		GlobalSoundManager.play(confirmMenu);
		switch (curSelected)
		{
			case 0:
				SaveData.gpu = true; // Não acho que um gama alta precise, mas...
				SaveData.antialiasing = true;
				SaveData.fps = 90;
			case 1:
				SaveData.gpu = true; // Não acho que um gama alta precise, mas...
				SaveData.antialiasing = false;
				SaveData.fps = 60;
			case 2:
				SaveData.gpu = false; // Não acho que um gama alta precise, mas...
				SaveData.antialiasing = false;
				SaveData.fps = 30;
		}

		if (curSelected < 3)
			SaveData.curPreset = curSelected;

		SaveData.save();

		MusicBeatState.switchState(new MainMenuState());
	}

	function save()
	{
		/*SaveData.shitMs = judgementTimings[0];
			SaveData.badMs = judgementTimings[1];
			SaveData.goodMs = judgementTimings[2];
			SaveData.sickMs = judgementTimings[3];

			SaveData.save();

			Ratings.timingWindows = [
				SaveData.shitMs,
				SaveData.badMs,
				SaveData.goodMs,
				SaveData.sickMs
			];

			Conductor.safeZoneOffset = Ratings.timingWindows[0]; */
	}

	function quit()
	{
		save();
		CoolUtil.flash(1);
		FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0}, 1.1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween)
			{
				MusicBeatState.switchState(new MainMenuState());
			}
		});
		FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected += _amount;

		if (curSelected > 3)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 3;
	}
}
