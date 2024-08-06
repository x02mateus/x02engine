package backend;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

class GPUManager
{ // Esse code também engloba mais do que só a GPU.
	public static function toGraphic(bitmap:BitmapData, key:String):FlxGraphic
	{
		var texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, false, 0);
		texture.uploadFromBitmapData(bitmap);
		Paths.currentTrackedTextures.set(key, texture);
		bitmap.disposeImage();
		flixel.util.FlxDestroyUtil.dispose(bitmap);
		bitmap = null;
		return FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, key);
	}

	public static function getGPUTexturesCount():Int
	{
		return Lambda.count(Paths.currentTrackedTextures); // As texturas da GPU vão pra esse coiso aí no Paths
	}

	public static function getCPUTexturesCount():Int
	{
		var assets:Map<String, FlxGraphic> = Paths.currentTrackedAssets;
		for (key in Paths.currentTrackedTextures.keys())
		{
			if (assets.exists(key))
			{
				assets.remove(key);
			}
		}
		return Lambda.count(assets);
	}

	public static function getImageRAM(?getGPU:Bool = false):String
	{ // Isso só se APROXIMA, ou seja, não é certeza que o número que isso retorna é realmente o uso.
		// isso veio do Pibby Apocalipse
		var expectedMemoryBytes:Float = 0;
		var processed:Array<FlxGraphic> = [];

		@:privateAccess
		for (key in Paths.currentTrackedAssets.keys())
		{
			var obj = Paths.currentTrackedAssets.get(key);
			if (processed.contains(obj))
				continue;
			expectedMemoryBytes += obj.width * obj.height * 4;

			processed.push(obj);
		}
		processed = null;

		return formatMemory(Std.int(expectedMemoryBytes));
	}

	private static function formatMemory(num:UInt):String
	{
		var size:Float = num;
		var data = 0;
		var dataTexts = ["B", "KB", "MB", "GB"];
		while (size > 1024 && data < dataTexts.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		var formatSize:String = formatAccuracy(size);
		return '${formatSize} ${dataTexts[data]}';
	}

	private static function formatAccuracy(value:Float)
	{
		var conversion:Map<String, String> = [
			'0' => '0.00',
			'0.0' => '0.00',
			'0.00' => '0.00',
			'00' => '00.00',
			'00.0' => '00.00',
			'00.00' => '00.00', // gotta do these as well because lazy
			'000' => '000.00'
		]; // these are to ensure you're getting the right values, instead of using complex if statements depending on string length

		var stringVal:String = Std.string(value);
		var converVal:String = '';
		for (i in 0...stringVal.length)
		{
			if (stringVal.charAt(i) == '.')
				converVal += '.';
			else
				converVal += '0';
		}

		var wantedConversion:String = conversion.get(converVal);
		var convertedValue:String = '';

		for (i in 0...wantedConversion.length)
		{
			if (stringVal.charAt(i) == '')
				convertedValue += wantedConversion.charAt(i);
			else
				convertedValue += stringVal.charAt(i);
		}

		if (convertedValue.length == 0)
			return '$value';

		return convertedValue;
	}
}
