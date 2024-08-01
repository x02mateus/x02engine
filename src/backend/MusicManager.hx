/*
 * Eu poderia considerar essa fase da engine como Managers update? Não sei... Me diz aí idklool :olhar_penetrante:
 * Esse code foi feito pra deixar as tarefas em relação as músicas de menus mais organizadas, e fazer a repetição de code em states não ser necessária.
 * Desse jeito, eu consigo rodar o playMusic() em todo state do jogo e mesmo assim as músicas não vão se repetir sempre.
 * Isso acontece por conta da array songsList, que toda vez que uma música nova é tocada, reconhece o nome dela e remove o nome dela de dentro da array
 */

package backend;

class MusicManager
{
	public static var curPlaying:String = "";
	private static var songsList:Array<String> = ["1", "2", "3", "4", "5", "6", "7"];

	public static function playMusic()
	{
		if (songsList == null || songsList.length == 0)
			songsList = ["1", "2", "3", "4", "5", "6", "7"];

		playlistOrder(true); // Aqui ele deixa a playlist mais aleatória

		var randomIndex:Int = Std.random(songsList.length);
		FlxG.sound.playMusic(Paths.music(songsList[randomIndex]), SaveData.volumeMusica, true);
		songsList.remove(curPlaying);

		#if debug
		trace('Tocando agora - Nome da musica: ${getSongInfo()[0]} / Nome do artista: ${getSongInfo()[1]} / Lista de musicas disponiveis: $songsList');
		#end
	}

	/*
	 * @return Retorna uma Array no seguinte formato: ["nome", "artista"]
	 */
	public static function getSongInfo():Array<String>
	{
		// Converti isso pra JSON pq tava muito feio...
		// Se você olhar dentro do JSON, é quase a mesma coisa do code original, só que...
		// Aqui fica bem mais bonito e compacto, e além do mais, FUNCIONA, então não mexe nisso kek
		// Isso já quebra um galho pro modding também, já que ajuda muito mais na hora de fazer a playlist
		var json:String = Utils.getContent("assets/data/songsData.json");
		var songsData = Json.parse(json);

		var songInfo = Reflect.field(songsData, curPlaying);
		return songInfo != null ? [songInfo.nome, songInfo.artista, songInfo.album] : [null, null, null];
	}

	public static function getSongAlbum()
	{
		return Paths.image('songs/albuns/${getSongInfo()[2]}');
	}

	private static function playlistOrder(random:Bool = true)
	{
		if (random)
			songsList = Random.shuffle(songsList);
		else
			songsList = ["1", "2", "3", "4", "5", "6", "7"];
	}
}
