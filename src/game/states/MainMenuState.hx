package game.states;

import objects.MenuButton;

class MainMenuState extends MusicBeatState
{
	private var canClick:Bool = true;
	private var background:FlxSprite;
	private var versionText:FlxText;
	private var buttons:MenuButton;

	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		Main.mouse_allowed = true;

		background = createBackground();
		add(background);

		versionText = createVersionText();
		add(versionText);

		buttons = new MenuButton(); // Tive problema com isso hoje mais cedo, daí, arrumei e por algum motivo coloquei o code bugado denovo : D (alguém me mata por favor)
		add(buttons);

		super.create();
	}

	private function createBackground():FlxSprite
	{
		var bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1, 2)}', 'preload'));
		bg.moves = false;
		bg.antialiasing = SaveData.antialiasing;
		bg.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
		return bg;
	}

	private function createVersionText():FlxText
	{
		var txt = new FlxText(0, FlxG.height - 24, 0, "X02Engine BETA v0.1", 12);
		txt.scrollFactor.set();
		txt.setFormat(Paths.font('akira.otf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.moves = false;
		txt.antialiasing = SaveData.antialiasing;
		return txt;
	}

	public static function abrirState(pressed:String)
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
					MusicBeatState.switchState(new game.states.options.AjustesState());
				case "freeplay":
					MusicBeatState.switchState(new game.states.FreeplayStateX02());
			}
		});
	}
}
