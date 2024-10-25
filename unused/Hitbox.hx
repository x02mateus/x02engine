package input.mobile.ui;

/*
 * Eu decidi reescrever isso pq eu gosto de sempre fazer umas coisas diferenciadas e achei que esse code tava precisando :D
 * @author MateusX02
*/
#if MOBILE_CONTROLS
import flixel.ui.FlxButton;

class Hitbox extends FlxSpriteGroup
{
	private var hitboxGroup:FlxSpriteGroup;
    private var hitbox_hint:FlxSprite;
    private var sizex:Int = 320;
    private var buttonsCoords:Array<Int>;
    public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
    public var buttonsArray:Array<FlxButton>;

    // = new Hitbox(SaveData.hitboxSkin) - só pra caso eu me esqueça
	public function new(skin:String = "default", ?screenWidth:Int)
	{
		super();
        
        this.scrollFactor.set();
        sizex = screenWidth != null ? Std.int(screenWidth / 4) : 320;
        buttonsCoords = [0, sizex, sizex * 2, sizex * 3];
        buttonsArray = [buttonLeft, buttonDown, buttonUp, buttonRight];

        hitbox_hint = new FlxSprite(0, 0).loadGraphic(Paths.image('hitbox/hitbox_hint_$skin', 'mobile'));
        hitbox_hint.y = FlxG.height - hitbox_hint.height;
		hitbox_hint.alpha = 0.2;
		add(hitbox_hint);
        
		for (i in 1...4)
			add(buttonsArray[i - 1] = createButton(buttonsCoords[i - 1], i)); // iiiiiiiiiii....
	}

	private function createButton(x:Int, anim:Int) {
		var button:FlxButton = new FlxButton(x, 0);
        var frames = Paths.getSparrowAtlas('hitbox/hitbox_$skin', 'mobile');
		button.loadGraphic(flixel.graphics.FlxGraphic.fromFrame(frames.getByName(Std.string(anim))));
		button.alpha = 0;
		button.visible = false;

		button.onDown.callback = function() { 
            onDown(button);
        }
		button.onUp.callback = function() { 
            onUp(button);
        }
		button.onOut.callback = function() { 
            onOut(button);
        }

		return button;
	}

    private function onDown(button:FlxButton):Void {
        button.visible = true;
        FlxTween.tween(button, { alpha : 0.75 }, .075, { ease: FlxEase.circInOut });
    }

    private function onUp(button:FlxButton):Void {  
        FlxTween.tween(button, { alpha : 0 }, .1, { ease: FlxEase.circInOut, onComplete: function(twn:FlxTween) {
            button.visible = false;
        }});
    }

    private function onOut(button:FlxButton):Void {
        FlxTween.tween(button, { alpha : 0 }, .2, { ease: FlxEase.circInOut, onComplete: function(twn:FlxTween) {
            button.visible = false;
        }});
    }

    override public function destroy():Void {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}
#end