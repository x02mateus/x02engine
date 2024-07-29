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
		if (songsList == null)
			songsList = ["1", "2", "3", "4", "5", "6", "7"];

		FlxG.sound.playMusic(Paths.music(songsList[FlxG.random.int(1, songsList.length)]), SaveData.volumeMusica, true);

		songsList.remove(curPlaying);

		#if debug
		trace('Tocando agora - Nome da musica: ${getSongName()[0]} / Nome do artista: ${getSongName()[1]} / Lista de musicas disponiveis: $songsList');
		#end
	}

	/*
	 * @return Retorna uma Array no seguinte formato: ["nome", "artista"]
	 */
	public static function getSongName():Array<String>
	{
		// Isso não funcionou usando a função do Flixel, então eu tive que fazer esse code feio aqui :skull:
		switch (curPlaying)
		{
			case "1":
				return ["aquatic ambiance", "scizzie"];
			case "2":
				return ["LEASE", "Takeshi Abo"];
			case "3":
				return ["Relaxed Scene", "James Clarke"];
			case "4":
				return ["WINDOWS 95", 'Che Mac'];
			case "5":
				return ["Lotus Waters", 'Yume 2ikki'];
			case "6":
				return ["SR20DET", "BLKSMIITH"];
			case "7":
				return ["Virtual Tears", "TOKYOPILL"];
		}
		return [null, null];
	}

	public static function getSongAlbum()
	{
		return Paths.image('songs/albuns/$curPlaying');
	}
}
