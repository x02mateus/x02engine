package objects;

class FreeplayButton extends FlxSpriteGroup {
    var bg:FlxSprite;
    var song_name:FlxText;

    public function new(metadata_songname:String) {
        super();

        bg = new FlxSprite().loadGraphic(Paths.image('freeplay/song_button'));
        bg.moves = false;
        bg.antialiasing = SaveData.antialiasing;
        add(bg);

        song_name = new FlxText(25.10, 15.24, metadata_songname, 36);
        song_name.font = Paths.font('akira.otf');
        song_name.antialiasing = SaveData.antialiasing;
        add(song_name);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}