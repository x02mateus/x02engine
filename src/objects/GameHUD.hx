package objects;

import backend.Ratings;

class GameHUD extends FlxSpriteGroup {
    private var engine_watermark:FlxText;
    private var songname_display:FlxText;
    public var accuracy:FlxText;
    public var score:FlxText;
    public var misses:FlxText;

    public function new(song_name:String) {
        super();

        engine_watermark = new FlxText(0, FlxG.height, "[ - X02Engine BETA v0.1 - ]", 20);
        engine_watermark.font = Paths.font('akira.otf');
        engine_watermark.antialiasing = SaveData.antialiasing;
        engine_watermark.moves = false;
        engine_watermark.y -= engine_watermark.height;
        add(engine_watermark);

        songname_display = new FlxText(FlxG.width, 0, '[ - $song_name - ]', 20);
        songname_display.font = Paths.font('akira.otf');
        songname_display.antialiasing = SaveData.antialiasing;
        songname_display.moves = false;
        songname_display.x -= songname_display.width;
        add(songname_display);

        accuracy = new FlxText(FlxG.width, songname_display.height, '[ - Precisão: 0.00% (N/A) - ]', 20);
        accuracy.font = Paths.font('akira.otf');
        accuracy.antialiasing = SaveData.antialiasing;
        accuracy.moves = false;
        accuracy.x -= accuracy.width;
        add(accuracy);

        score = new FlxText(FlxG.width, accuracy.y+accuracy.height, '[ - Pontuação: 0 - ]', 20);
        score.font = Paths.font('akira.otf');
        score.antialiasing = SaveData.antialiasing;
        score.moves = false;
        score.x -= score.width;
        add(score);

        misses = new FlxText(0, FlxG.height, '[ - Erros: 0 - ]', 20);
        misses.font = Paths.font('akira.otf');
        misses.antialiasing = SaveData.antialiasing;
        misses.moves = false;
        misses.screenCenter(X);
        misses.y -= 7;
        add(misses);
    }

    inline public function updateMisses(misses:Int) {
        this.misses.text = '[ - Erros: ${Std.string(misses)} - ]';
    }

    inline public function updateScore(score:Int) {
        this.score.text = '[ - Pontuação: ${Std.string(score)} - ]';
    }

    inline public function updateAccuracy(acc:Int) {
        this.accuracy.text = '[ - Pontuação: ${Ratings.accuracytoString(acc)} - ]';
    }
}