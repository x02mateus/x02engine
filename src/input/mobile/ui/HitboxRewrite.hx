package input.mobile.ui;

/*
 * Eu decidi reescrever isso, por motivos de performance/um code que eu saiba mexer melhor/o code do LuckyDog é antigo demais e pode mudar um pouco :D
 * @author MateusX02
*/
#if mobileC
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.ui.FlxButton;

class HitboxRewrite extends FlxSpriteGroup
{
	private var hitboxGroup:FlxSpriteGroup;
    private var hitbox_hint:FlxSprite;
    public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
    public var buttonsArray:Array<FlxButton>;
    private var sizex:Int = 320;
    private var buttonsCoords:Array<Int>;

	public function new(?screenWidth:Int)
	{
		super();
        
        sizex = screenWidth != null ? Std.int(screenWidth / 4) : 320;
        buttonsCoords = [0, sizex, sizex * 2, sizex * 3];
        buttonsArray = [buttonLeft, buttonDown, buttonUp, buttonRight];

        hitbox_hint = new FlxSprite(0, 0).loadGraphic(Paths.image('hitbox/hitbox_hint', 'mobile'));
        hitbox_hint.y = FlxG.height - hitbox_hint.height;
		hitbox_hint.alpha = 0.2;
		add(hitbox_hint);
        
		for (i in 1...4)
			hitboxGroup.add(add(buttonsArray[i - 1] = createButton(buttonsCoords[i - 1], i))); // iiiiiiiiiii....
	}

	private function createButton(x:Int, anim:Int) {
		var button:FlxButton = new FlxButton(x, 0);
        var frames = fromSparrow();
		var graphic:FlxGraphic = FlxGraphic.fromFrame(frames.getByName(Std.string(anim)));

        button.loadGraphic(graphic);
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

    private function fromSparrow() { // Isso só é usado uma única vez, só que a única vez que é usado é de uma forma tremendamente feia
        // Btw, isso é a mesma coisa de usar Paths.getSparrowAtlas, só que o do Paths não funcionou por algum motivo esquisito
        return FlxAtlasFrames.fromSparrow(Paths.getPath('images/hitbox/hitbox.png', IMAGE, "mobile"), Assets.getText(Paths.getPath('images/hitbox/hitbox.xml', TEXT, "mobile")));
    }

    override public function destroy():Void {
        super.destroy();
    
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}
#end