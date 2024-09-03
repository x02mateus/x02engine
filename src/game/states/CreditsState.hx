package game.states;

import flixel.util.FlxAxes;

class CreditsState extends MusicBeatState
{
	var icon:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var bg:FlxSprite;
	var curSelected:Int = 0;
	var pessoas:Array<String> = ['mateusx02', 'Matheus Silver', 'idklool', 'Evil'];
	var icons:Array<String> = ['mateusx02', 'silver', 'idklool', 'mari'];
	var cargos:Array<String> = [LanguageManager.getString('x02_work', 'Credits'), LanguageManager.getString('silver_work', 'Credits'), LanguageManager.getString('idklool_work', 'Credits'), LanguageManager.getString('mari_work', 'Credits')];
	var desc:Array<String> = [
		'capybara',
		'',
		'',
		''
	];
	var yt:Array<String> = [
		'https://www.youtube.com/@mateusx02',
		'https://www.youtube.com/@MatheusSilver',
		'https://www.youtube.com/@idklool122',
		''
	];
	var infoText:FlxText;
	override function create()
	{
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();
		
		Main.mouse_allowed = true;

		bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1, 2)}', 'preload'));
		bg.moves = false;
		bg.antialiasing = SaveData.antialiasing;
		bg.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
		add(bg);

		icon = new FlxSprite().loadGraphic(Paths.image('credits/${icons[curSelected]}'));
		icon.moves = false;
		icon.antialiasing = SaveData.antialiasing;
		icon.screenCenter(XY);
		add(icon);

		// arrows
		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		leftArrow = new FlxSprite(icon.x - 60, 0);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.antialiasing = false;
		leftArrow.screenCenter(Y);
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(icon.x + icon.width + 20, 0);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.antialiasing = false;
		rightArrow.screenCenter(Y);
		rightArrow.animation.play('idle');
		add(rightArrow);

		infoText = createInfoText();
		add(infoText);

		changeItem(0);

		super.create();
	}

	override function update(elapsed:Float) {
		if(controls.LEFT_P || BSLTouchUtils.apertasimples(leftArrow)) {
			leftArrow.animation.play('press');
			new FlxTimer().start(0.15, function(tmr:FlxTimer) {
				leftArrow.animation.play('idle');
				changeItem(1);
			});
		} if(controls.RIGHT_P || BSLTouchUtils.apertasimples(rightArrow)) {
			rightArrow.animation.play('press');
			new FlxTimer().start(0.15, function(tmr:FlxTimer) {
				rightArrow.animation.play('idle');
				changeItem(-1);
			});
		}

		if(yt[curSelected] != null && (controls.ACCEPT || BSLTouchUtils.apertasimples(icon))) {
			GlobalSoundManager.play(confirmMenu);
			CoolUtil.browserLoad(yt[curSelected]);
		}

		if(controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new MainMenuState());
		}

	}

	private function createInfoText():FlxText
	{
		var txt = new FlxText(-10, 580, 1280, '', 72);
		txt.scrollFactor.set(0, 0);
		txt.setFormat(Paths.font("akira.otf"), 21, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		txt.borderSize = 2;
		txt.borderQuality = 3;
		txt.screenCenter(FlxAxes.X);
		txt.antialiasing = SaveData.antialiasing;
		return txt;
	}

	private function changeItem(aaa:Int) {
		GlobalSoundManager.play(scrollMenu);
		curSelected += aaa;

		if(curSelected > 3)
			curSelected = 0;
		if(curSelected < 0)
			curSelected = 3;

		infoText.text = '${pessoas[curSelected]}\n\n${cargos[curSelected]}\n\n${desc[curSelected]}';

		icon.loadGraphic(Paths.image('credits/${icons[curSelected]}'));
	}
}
