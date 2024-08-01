package objects;

class MusicIndicator extends FlxSpriteGroup
{
	private var bg:FlxSprite;
	private var album:FlxSprite;
	private var songName:FlxText;
	private var songArtist:FlxText;
	private var playpauseButton:FlxSprite;

	private var playbackStatus:String = "pause";

	public function new()
	{
		super();

		bg = new FlxSprite().loadGraphic(Paths.image("songs/popup/bg"));
		bg.antialiasing = SaveData.antialiasing;
		bg.moves = false;
		add(bg);

		album = new FlxSprite().loadGraphic(MusicManager.getSongAlbum());
		album.antialiasing = SaveData.antialiasing;
		album.moves = false;
		album.setGraphicSize(102, 102);
		album.x = album.y = 8;
		add(album);

		songName = new FlxText(117.77, 31.62, MusicManager.getSongInfo()[0], 22);
		songName.antialiasing = SaveData.antialiasing;
		songName.moves = false;
		songName.alignment = LEFT;
		songName.font = Paths.font("akira.otf");
		add(songName);

		songArtist = new FlxText(235.52, 54.55, MusicManager.getSongInfo()[1], 12);
		songArtist.antialiasing = SaveData.antialiasing;
		songArtist.moves = false;
		songArtist.alignment = CENTER;
		songArtist.font = Paths.font("akira.otf");
		add(songArtist);

		playpauseButton = new FlxSprite().loadGraphic(Paths.image('songs/popup/$playbackStatus'));
		playpauseButton.setGraphicSize(32, 32);
		playpauseButton.updateHitbox();
		add(playpauseButton);
	}

	override function update(elapsed:Float)
	{
		if (BSLTouchUtils.apertasimples(playpauseButton))
		{
			playbackStatus = (playbackStatus == "pause") ? "play" : "pause";

			playpauseButton.loadGraphic(Paths.image('songs/popup/$playbackStatus'));

			switch (playbackStatus)
			{
				case "pause":
					FlxG.sound.music.resume();
				case "play":
					FlxG.sound.music.pause();
			}
		}

        if (BSLTouchUtils.apertasimples(bg))
            destroy();
	}
}
