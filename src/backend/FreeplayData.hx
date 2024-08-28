package backend;

// Esse bloco de code em específico só serve pra diminuir um pouco o tanto de linhas que eu usaria no FreeplayState
// Meio que isso funciona como um "manager" também, mas, eu tinha como ideia só deixar as coisas menores e mais organizadas.

import game.states.FreeplayStateX02;

class FreeplayData {
    public static var base_songs:Array<String> = [ // Não tenho a PE mais nova, então vai ficar sem a week 7 k
        'Tutorial',
        'Bopeebo',
        'Fresh',
        'Dad Battle',
        'Spookeez',
        'South',
        'Monster',
        'Pico',
        'Philly Nice',
        'Blammed',
        'Satin Panties',
        'High',
        'Milf',
        'Cocoa',
        'Eggnog',
        'Winter Horrorland', // k
        'Senpai',
        'Roses',
        'Thorns',
        'Test'
    ];

    public static function addSongsByList(list:Array<String>):Void {
        var songs:Array<String> = list;
        var songsWeek:Int = (songs == base_songs) ? 0 : 1;
        for (i in songs) 
            addSong(i, songsWeek);
    }

    private static function addSong(songName:String, weekNum:Int)
	{
		FreeplayStateX02.songs.push(new SongMetadata(songName, weekNum));
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var folder:String = "";

	public function new(song:String, week:Int)
	{
		this.songName = song;
		this.week = week;
		this.folder = '';
	}
}