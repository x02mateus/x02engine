package game.states;

// Alguém me ajuda... por favor
// Eu só queria que a lista das músicas se mexessem quando você desce ou sobe com os controles...
// Por algum motivo isso é uma dificuldade pra mim

import backend.FreeplayData;
import objects.FreeplayButton;

class FreeplayStateX02 extends MusicBeatState
{
	private var bg:FlxSprite;
	private var fpBar:FlxSprite;
	private var bttBar:FlxSprite;
	private var curSelected:Int = 0;
	private var grpSongs:FlxTypedGroup<FreeplayButton>;
	private var apertavel:Bool = true;

	public static var songs:Array<SongMetadata> = [];

	override function create()
	{
		// Isso permite que você possa usar o mouse/teclado/gamepad no mesmo menu
		Main.mouse_allowed = true; // detalhe importantíssimo

		bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/2', 'preload'));
		bg.moves = false;
		bg.antialiasing = SaveData.antialiasing;
		bg.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
		add(bg);

		grpSongs = new FlxTypedGroup<FreeplayButton>();
		add(grpSongs);

		FreeplayData.addSongsByList(FreeplayData.base_songs);
		for (i in 0...songs.length)
		{
			var songbutton:FreeplayButton = new FreeplayButton(songs[i].songName);
			songbutton.x = FlxG.width - songbutton.width + (582 - 385); // - posição do botão inativo
			songbutton.y = 81 + 20 + (86 * i); // math
			songbutton.ID = i;
			grpSongs.add(songbutton);
		}

		fpBar = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/fpBar', 'preload'));
		fpBar.moves = false;
		fpBar.antialiasing = SaveData.antialiasing;
		add(fpBar);

		bttBar = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/bttBar', 'preload'));
		bttBar.moves = false;
		bttBar.antialiasing = SaveData.antialiasing;
		bttBar.y = FlxG.height - bttBar.height;
		add(bttBar);

		super.create();
	}

	var reload:Bool = false;

	override function update(elapsed:Float)
	{
        var accepted:Bool = controls.ACCEPT;
		if(Main.getMouseVisibility() && apertavel) {
			for (item in grpSongs.members) {
				if(BSLTouchUtils.apertasimples(item)) {
					apertavel = false;
					accepted = true;
				}
			}
		}

		if (apertavel)
		{
			if (controls.UP_P)
			{
				changeSelection(-1);
			}
			if (controls.DOWN_P)
			{
				changeSelection(1);
			}
		}
		if (apertavel && controls.BACK)
		{
			apertavel = false;
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new game.states.MainMenuState());
		}

		if (accepted) {
			trace('era pra ido pro Playstate né, mas eu tô com preguiça/não sei como fazer grande parte desse menu...');
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)	curSelected = songs.length - 1;
		if (curSelected >= songs.length)	curSelected = 0;
	}
}