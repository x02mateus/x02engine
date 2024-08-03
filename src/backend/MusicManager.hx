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
		FlxG.sound.playMusic(Paths.music(songsList[randomIndex]), SaveData.volumeMusica, false);
		songsList.remove(curPlaying);
	}

	private static function playlistOrder(random:Bool = true)
	{
		if (random)
			songsList = Random.shuffle(songsList);
		else
			songsList = ["1", "2", "3", "4", "5", "6", "7"];
	}
}
