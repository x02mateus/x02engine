package objects;

class MenuButton extends FlxSpriteGroup
{
	private var freeplay:FlxSprite = new FlxSprite();
	private var options:FlxSprite = new FlxSprite();
	private var credits:FlxSprite = new FlxSprite();
	private var sharedTexture = Paths.getSparrowAtlas("mainmenu/sharedtexture", "preload");

	public function new()
	{
		super();

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
	}

	override function update(elapsed:Float)
	{
		if (BSLTouchUtils.apertasimples(credits) || BSLTouchUtils.apertasimples(freeplay))
			game.states.MainMenuState.abrirState("uhhhhhh");
		if (BSLTouchUtils.apertasimples(options))
			game.states.MainMenuState.abrirState("options");

		super.update(elapsed);
	}
}
