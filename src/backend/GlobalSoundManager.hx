package backend;

class GlobalSoundManager
{
	public static var confirm:FlxSound;
	public static var cancel:FlxSound;

	public static var listaDeSons:Array<String> = []; // Por algum motivo a lista de FlxSound não funfa aqui... Devéras sus

	public static function init(?som:FlxSound):Void
	{
		if (som == confirm)
		{
			confirm = null;
			confirm = new FlxSound().loadEmbedded(Paths.sound('confirmMenu', 'preload'));
			confirm.volume = 0.7;
			FlxG.sound.list.add(confirm);
		}

		if (som == cancel)
		{
			cancel = null;
			cancel = new FlxSound().loadEmbedded(Paths.sound('cancelMenu', 'preload'));
			cancel.volume = 0.7;
			FlxG.sound.list.add(cancel);
		}
	}

	public static function play(som:String):Void
	{
		if (0.7 > 0)
		{
			switch (som)
			{
				case 'confirmMenu':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(confirm);

					confirm.play(true);
				case 'cancelMenu':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(cancel);

					cancel.play(true);
			}
		}
	}

	public static function verifiqueSeExisteEentaoadicione(nome:String):Bool
	{
		if (!listaDeSons.contains(nome))
		{
			listaDeSons.push(nome);
			return false;
		}
		else
			return true;
	}
}
