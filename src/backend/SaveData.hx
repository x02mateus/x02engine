package backend;

class SaveData
{
	// Data
	public static var firstTime:Null<Bool> = true;
	public static var hitSoundVolume:Null<Float> = 0;
	public static var volumeMusica:Null<Float> = 1;
	public static var volumeEfeitos:Null<Float> = 1;

	// Mobile Controls data
	public static var buttonsMode:Array<Dynamic> = [];
	public static var buttons:Array<Dynamic> = [];

	// Gráficos
	public static var fps:Null<Int> = 60;
	public static var antialiasing:Null<Bool> = true;
	public static var gpu:Null<Bool> = false;

	// Gameplay
	public static var missSounds:Null<Bool> = false;
	public static var scrollSpeed:Null<Float> = 1;
	public static var botplay:Null<Bool> = false;
	public static var hitSound:Null<Int> = 0;

	// UI
	public static var downscroll:Null<Bool> = false;
	public static var middlescroll:Null<Bool> = false;
	public static var songPosition:Null<Bool> = false;
	public static var showFPS:Null<Bool> = false;

	private static var importantMap:Map<String, Array<String>> = ["flixelSound" => ["volume"]];

	/** Quick Function to Fix Save Files for Flixel 5
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'mateusx02'):String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public static function init()
	{
		FlxG.save.bind('x02engine', getSavePath());

		// https://github.com/ShadowMario/FNF-PsychEngine/pull/11633
		for (field in Type.getClassFields(SaveData))
		{
			if (Type.typeof(Reflect.field(SaveData, field)) != TFunction)
			{
				if (!importantMap.get("flixelSound").contains(field))
				{
					var defaultValue:Dynamic = Reflect.field(SaveData, field);
					var flxProp:Dynamic = Reflect.field(FlxG.save.data, field);
					Reflect.setField(SaveData, field, (flxProp != null ? flxProp : defaultValue));
				}
			}
		}

		for (flixelS in importantMap.get("flixelSound"))
		{
			var flxProp:Dynamic = Reflect.field(FlxG.save.data, flixelS);

			if (flxProp != null)
				Reflect.setField(FlxG.sound, flixelS, flxProp);
		}
	}

	public static function save()
	{
		// ensure that we're saving (hopefully)
		if (FlxG.save.data == null)
			FlxG.save.bind('x02engine', getSavePath());

		for (field in Type.getClassFields(SaveData))
		{
			if (Type.typeof(Reflect.field(SaveData, field)) != TFunction)
				Reflect.setField(FlxG.save.data, field, Reflect.field(SaveData, field));
		}

		for (flixel in importantMap.get("flixelSound"))
			Reflect.setField(FlxG.save.data, flixel, Reflect.field(FlxG.sound, flixel));

		FlxG.save.flush();
	}
}