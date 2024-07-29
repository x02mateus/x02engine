package game.states;

// Decidi rushar esse menu escutando Master of Puppets do Metallica, então ignore se o code estiver burro k
class MainMenuState extends MusicBeatState
{
	private var canClick:Bool = true;
	private var background:FlxSprite;
	private var versionText:FlxText;

	public var freeplay:FlxSprite = new FlxSprite();
	public var options:FlxSprite = new FlxSprite();
	public var credits:FlxSprite = new FlxSprite();

	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		if (FlxG.sound.music == null)
			MusicManager.playMusic();

		Main.mouseVisibility(true); // Isso serve pra deixar o mouse visivel, e não precisar colocar um novo code para ele não ficar visível no Android

		// Breve explicação de como funcionam os sprites nessa engine
		background = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1, 2)}',
			'preload')); // Carrega a imagem usando o Paths.image, e procura por ela em 'preload/images/background/(bg 1 ou 2)'
		background.moves = false; // Desativa o sistema de colisão para o aumento de performance (Não tem necessidade de utilizar o sistema de colisão, já que o BG foi feito para ser apenas um fundo)
		background.antialiasing = SaveData.antialiasing; // Ativa ou desativa o antialiasing da imagem de acordo com o que o usuário tiver escolhido
		background.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height)); // Faz a imagem preencher a tela inteira
		add(background); // Adiciona a imagem

		versionText = new FlxText(0, FlxG.height - 24, 0, "X02Engine BETA v0.1", 12);
		versionText.scrollFactor.set();
		versionText.setFormat(Paths.font('akira.otf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		freeplay.loadGraphic(Paths.image("mainmenu/freeplay"));
		freeplay.x = 120;
		freeplay.screenCenter(Y);
		freeplay.moves = false;
		freeplay.antialiasing = SaveData.antialiasing;
		add(freeplay);

		options.loadGraphic(Paths.image("mainmenu/options"));
		options.x = freeplay.x + freeplay.width;
		options.y = freeplay.y;
		options.moves = false;
		options.antialiasing = SaveData.antialiasing;
		add(options);

		credits.loadGraphic(Paths.image("mainmenu/credits"));
		credits.x = freeplay.x + freeplay.width;
		credits.y = options.y + options.height;
		credits.moves = false;
		credits.antialiasing = SaveData.antialiasing;
		add(credits);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (BSLTouchUtils.apertasimples(credits))
			abrirState("credits");
		if (BSLTouchUtils.apertasimples(freeplay) || BSLTouchUtils.apertasimples(options))
			abrirState("uhhhhhh");

		super.update(elapsed);
	}

	private function abrirState(pressed:String)
	{
		CoolUtil.flash(0.5);
		GlobalSoundManager.play(confirmMenu);
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			switch (pressed)
			{
				case "credits":
					MusicBeatState.switchState(new game.states.CreditsState());
				case "options":
					#if mobileC
					// MusicBeatState.switchState(new options.MobileKeyBinds());
					#else
					FlxG.openURL("https://youtu.be/IUtKOuB11gM?si=wWxNaH9PT0QET08w");
					#end
				default:
					FlxG.openURL("https://youtu.be/IUtKOuB11gM?si=wWxNaH9PT0QET08w");
			}
		});
	}
}
