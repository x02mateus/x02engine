package objects;

class MenuButton extends FlxSpriteGroup
{
	private var freeplay:FlxSprite;
	private var options:FlxSprite;
	private var credits:FlxSprite;
	private var sharedTexture = Paths.getSparrowAtlas("mainmenu/sharedtexture", "preload");

	public function new()
	{
		super();

		freeplay = createButtonSprite(sharedTexture, "freeplay", 120, 0);
		options = createButtonSprite(sharedTexture, "options", freeplay.x + freeplay.width, freeplay.y);
		credits = createButtonSprite(sharedTexture, "credits", freeplay.x + freeplay.width, freeplay.y + options.height);

		add(freeplay);
		add(options);
		add(credits);
	}

	private function createButtonSprite(frames:flixel.graphics.frames.FlxAtlasFrames, animationName:String, x:Float, y:Float):FlxSprite
	{
		var sprite:FlxSprite = new FlxSprite();
		sprite.frames = frames;
		sprite.animation.addByPrefix(animationName, animationName);
		sprite.animation.play(animationName);
		sprite.x = x;
		sprite.y = y;
		sprite.screenCenter(Y);
		sprite.moves = false;
		sprite.antialiasing = SaveData.antialiasing;
		return sprite;
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
