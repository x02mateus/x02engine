package game.states.options;

class AjustesState extends MusicBeatState {
    private var bg:FlxSprite;
    private var options:Array<String> = ['Configuracoes', 'Linguagem'];
    private var option_buttons:FlxTypedGroup<FlxText>;
    private var curSelected:Int = 0;
    public static var selectedSomethin:Bool = false;
    
    override function create() {
        Main.mouse_allowed = true;
        persistentUpdate = persistentDraw = true;

        #if mobileC
        options.push('Controles Mobile');
        #end

        bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1, 2)}', 'preload'));
        bg.moves = false;
        bg.antialiasing = SaveData.antialiasing;
        bg.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
		add(bg);

        option_buttons = new FlxTypedGroup<FlxText>();
		add(option_buttons);

        var k:Int = Math.floor((FlxG.height - 115 * options.length) / 2);

        for (i in 0...options.length) {
            var opcaoNome:FlxText = new FlxText(0, k + 115 * i, 0, options[i]);
            opcaoNome.font = Paths.font('akira.otf');
            opcaoNome.size = 42;
            opcaoNome.screenCenter((options.length == 1) ? XY : X);
            opcaoNome.updateHitbox();
            opcaoNome.ID = i;
            opcaoNome.alpha = 0.75;
            option_buttons.add(opcaoNome);
        }

        super.create();
    }

    private function handle_input():Void {
		if (controls.DOWN_P)
		{
			if (curSelected + 1 > options.length - 1)
				curSelected = 0;
			else{
				curSelected +=1;
			}
		}
		else if (controls.UP_P)
		{
			if (curSelected - 1 < 0)
				curSelected = options.length - 1;
			else{
				curSelected -= 1;
			}
		}
	}

    override function update(elapsed:Float) {
        if(!selectedSomethin) {
            handle_input();
            option_buttons.forEach(function(object:FlxText){
                if (Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(object) : controls.ACCEPT && curSelected == object.ID)
                    click(object);
                else if (Main.getMouseVisibility() ? BSLTouchUtils.over(object) : curSelected == object.ID)
                    hover(object);
                else if (object.alpha == 1)
                    out(object);
            });
        }

        if (!selectedSomethin && controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
            selectedSomethin = true;
            GlobalSoundManager.play(cancelMenu);
            SaveData.save();
            MusicBeatState.switchState(new game.states.MainMenuState());
            selectedSomethin = false;
        }
        super.update(elapsed);
    }

    function hover(object:FlxText):Void {
		if (object.alpha != 1){ // pra ele n ficar repetindo o som
			GlobalSoundManager.play(scrollMenu);
			object.alpha = 1;
			curSelected = object.ID;
		}
	}
		
	function out(object:FlxText):Void {
		object.alpha = 0.75;
	}

	function click(object:FlxText):Void {
		object.alpha = 1;
		select(curSelected);
	}

	function select(curSelected) {
		GlobalSoundManager.play(confirmMenu);
		Main.mouse_allowed = false;
		selectedSomethin = true;
		redirect(curSelected);
	}

    function redirect(selecionado:Int){
		option_buttons.forEach(function(button:FlxText){
			if (button.ID == selecionado){
				button.alpha = 1;
				FlxTween.tween(button, {x: FlxG.width}, 0.5, {startDelay: 0.1, ease: FlxEase.expoInOut, onComplete:function(twn:FlxTween){
					next_state(options[selecionado]);
				}});
            }
		});
        selectedSomethin = false;
	}

	function next_state(state:String) {
		switch (state) {
		    case 'Configuracoes': 
                MusicBeatState.switchState(new game.states.options.ConfiguracoesState()); //graficos, gameplay e etc.
            case 'Linguagem': 
                MusicBeatState.switchState(new game.states.options.LanguagesState());
            #if mobileC
            case 'Controles Mobile': 
                MusicBeatState.switchState(new game.states.options.MobileKeyBinds());
            #end
		}	
	}
}