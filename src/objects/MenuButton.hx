package objects;

// Esse code me dá vontade de pegar uma **** e *** ** **** ** ***** **** :D
class MenuButton extends FlxSpriteGroup
{
	public var freeplay:FlxSprite = new FlxSprite();
	public var options:FlxSprite = new FlxSprite();
	public var credits:FlxSprite = new FlxSprite();
	private var sharedTexture = Paths.getSparrowAtlas('mainmenu/sharedtexture', "preload");
	public function new()
	{
		super();

		freeplay.frames = sharedTexture;
		freeplay.animation.addByPrefix("fp", "freeplay");
		freeplay.animation.play("fp");
		freeplay.x = 120;
		freeplay.screenCenter(Y);
		freeplay.moves = false;
		freeplay.antialiasing = SaveData.antialiasing;
		add(freeplay);

		options.frames = sharedTexture;
		options.animation.addByPrefix("op", "options");
		options.animation.play("op");
		options.x = freeplay.x + freeplay.width;
		options.y = freeplay.y;
		options.moves = false;
		options.antialiasing = SaveData.antialiasing;
		add(options);

		credits.frames = sharedTexture;
		credits.animation.addByPrefix("cr", "credits");
		credits.animation.play("cr");
		credits.x = freeplay.x + freeplay.width;
		credits.y = options.y + options.height;
		credits.moves = false;
		credits.antialiasing = SaveData.antialiasing;
		add(credits);

		credits.moves = options.moves = freeplay.moves = false;
		credits.antialiasing = options.antialiasing = freeplay.antialiasing = SaveData.antialiasing;
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