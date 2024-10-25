package input.mobile.ui;

#if MOBILE_CONTROLS
import flixel.ui.FlxButton;

/**
 *  Reescrevi esse code, tentando deixar tudo mais limpo e melhor de ler
 */

class Hitbox extends FlxSpriteGroup {
    public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

    private var buttonsCoords:Array<Int> = [0, 320, 320 * 2, 320 * 3];
    private var skin:String = "default";

    public function new(skin:String = "default") {
        super();

        this.skin = skin;

        var hint:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('hitbox/hitbox_hint_$skin'));
        hint.setGraphicSize(FlxG.width, FlxG.height);
        hint.screenCenter();        
        hint.moves = false;
        hint.antialiasing = SaveData.antialiasing;
        add(hint);

        add(buttonLeft = createHitbox(buttonsCoords[0], "1"));
		add(buttonDown = createHitbox(buttonsCoords[1], "2"));
		add(buttonUp = createHitbox(buttonsCoords[2], "3"));
		add(buttonRight = createHitbox(buttonsCoords[3], "4"));
    }

    private function createHitbox(x:Float, anim:String):FlxButton {
        var button:FlxButton = new FlxButton(x, 0);
        button.loadGraphic(Paths.loadHitboxSkin(skin, anim));
        button.setGraphicSize(Std.int(320), FlxG.height);
		button.updateHitbox();
        button.alpha = 0;

        var tween:FlxTween = null; // Silenciando aquele aviso chato da compilação.

		button.onDown.callback = function (){
			if (tween != null)
				tween.cancel();
            tween = FlxTween.tween(button, {alpha: 0.75}, 0.075, {ease: FlxEase.circInOut});
		};

		button.onUp.callback = function (){
			if (tween != null)
				tween.cancel();
            tween = FlxTween.tween(button, {alpha: 0}, 0.15, {ease: FlxEase.circInOut});
		}
		
		button.onOut.callback = function (){
			if (tween != null)
				tween.cancel();
            tween = FlxTween.tween(button, {alpha: 0}, 0.15, {ease: FlxEase.circInOut});
		}

		return button;
    }

    override public function destroy():Void
	{
		super.destroy();
		buttonLeft = buttonDown = buttonUp = buttonRight = null;
	}
}
#end