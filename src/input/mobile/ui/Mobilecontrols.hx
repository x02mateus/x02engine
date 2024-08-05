package input.mobile.ui;

#if mobileC
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import input.mobile.Config;
import input.mobile.ui.FlxVirtualPad;
import input.mobile.ui.HitboxRewrite;

class Mobilecontrols extends FlxSpriteGroup
{
	public var mode:ControlsGroup = HITBOX;

	public var _hitbox:HitboxRewrite;
	public var _virtualPad:FlxVirtualPad;

	public function new()
	{
		super();

		// load control mode num from Config.hx
		mode = getModeFromNumber(Config.getcontrolmode());
		trace(Config.getcontrolmode());

		switch (mode)
		{
			case VIRTUALPAD_RIGHT:
				initVirtualPad(0);
			case VIRTUALPAD_LEFT:
				initVirtualPad(1);
			case VIRTUALPAD_CUSTOM:
				initVirtualPad(2);
			case HITBOX:
				_hitbox = new HitboxRewrite();
				add(_hitbox);
			case KEYBOARD:
		}
	}

	function initVirtualPad(vpadMode:Int)
	{
		switch (vpadMode)
		{
			case 1:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
			case 2:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
				_virtualPad = Config.loadcustom(_virtualPad);
			default: // 0
				_virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
		}

		_virtualPad.alpha = 0.75;
		add(_virtualPad);
	}

	public static function getModeFromNumber(modeNum:Int):ControlsGroup
	{
		return switch (modeNum)
		{
			case 0: VIRTUALPAD_RIGHT;
			case 1: VIRTUALPAD_LEFT;
			case 2: KEYBOARD;
			case 3: VIRTUALPAD_CUSTOM;
			case 4: HITBOX;

			default: VIRTUALPAD_RIGHT;
		}
	}
}

enum ControlsGroup
{
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
	KEYBOARD;
	VIRTUALPAD_CUSTOM;
	HITBOX;
}
#end
