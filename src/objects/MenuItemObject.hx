package objects;

class MenuItemObject extends FlxSpriteGroup
{
	private var canClick:Bool = true;

	public var freeplay:FlxSprite = new FlxSprite();
	public var options:FlxSprite = new FlxSprite();
	public var credits:FlxSprite = new FlxSprite();

	public function new()
	{
		freeplay.loadGraphic("mainmenu/freeplay");
		freeplay.moves = false;
		freeplay.antialiasing = SaveData.antialiasing;
		add(freeplay);

		options.loadGraphic("mainmenu/options");
		options.x = freeplay.width;
		options.moves = false;
		options.antialiasing = SaveData.antialiasing;
		add(options);

		credits.loadGraphic("mainmenu/freeplay");
		credits.x = freeplay.width;
		credits.y = options.height;
		credits.moves = false;
		credits.antialiasing = SaveData.antialiasing;
		add(credits);
		super();
	}

	override function update(elapsed:Float)
	{
		if (BSLTouchUtils.apertasimples(freeplay) || BSLTouchUtils.apertasimples(options))
		{
			GlobalSoundManager.play('confirmMenu');
			FlxG.log.error("Esse menu ainda nao foi terminado kek");
		}
		else if (BSLTouchUtils.apertasimples(credits))
		{
			canClick = false;
			GlobalSoundManager.play('confirmMenu');
			Sys.exit(1);
		}
		super.update(elapsed);
	}
}
