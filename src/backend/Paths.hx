package backend;

import _openfl.utils.AssetCache;
import _openfl.utils.IAssetCache;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.utils.AssetType;

using StringTools;

#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#elseif java
import java.vm.Gc;
#elseif neko
import neko.vm.Gc;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	public static var localTrackedAssets:Array<String> = [];
	public static var currentTrackedTextures:Map<String, Texture> = [];
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var currentTrackedSounds_cacheID:Map<String, String> = [];

	public static final extensions:Map<String, String> = ["image" => "png", "audio" => "ogg", "video" => "mp4"];

	public static var dumpExclusions:Array<String> = [];

	public static var cache:IAssetCache = new AssetCache();

	public static function excludeAsset(key:String):Void
	{
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static function clear_memory_by_key(key:String, remove_local_mem:Bool = false)
	{
		if (currentTrackedAssets.exists(key) && !dumpExclusions.contains(key))
		{
			var obj = currentTrackedAssets.get(key);
			@:privateAccess
			if (obj != null)
			{
				if (currentTrackedTextures.exists(key))
				{
					var texture = currentTrackedTextures.get(key);
					texture.dispose();
					texture = null;
					currentTrackedTextures.remove(key);
				}
				cache.removeBitmapData(key);
				cache.clearBitmapData(key);
				cache.clear(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
				FlxDestroyUtil.dispose(obj.bitmap);
				currentTrackedAssets.remove(key);
			}
		}
		else if (currentTrackedSounds_cacheID.exists(key))
		{
			var sound_id:String = currentTrackedSounds_cacheID.get(key);
			currentTrackedSounds_cacheID.remove(key);
			cache.removeSound(sound_id);
			cache.clearSounds(sound_id);
			currentTrackedSounds.remove(sound_id);
			key = sound_id;
		}

		if (remove_local_mem)
			localTrackedAssets.remove(key);
	}

	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		var counter:Int = 0;
		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				clear_memory_by_key(key);
				counter++;
			}
		}

		// run the garbage collector for good measure lmfao
		#if (cpp || neko || java || hl)
		Gc.run(true);
		Gc.compact();
		#end
	}

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
			clear_memory_by_key(key);

		#if PRELOAD_ALL
		// clear all sounds that are cached
		var counterSound:Int = 0;
		for (key in currentTrackedSounds_cacheID.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
			{
				// trace('test: ' + dumpExclusions, key);
				clear_memory_by_key(key);
				counterSound++;
				// Debug.logTrace('Cleared and removed $counterSound cached sounds.');
			}
		}

		// Clear everything everything that's left
		var counterLeft:Int = 0;
		for (key in cache.getKeys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
			{
				cache.clear(key);
				counterLeft++;
				// Debug.logTrace('Cleared and removed $counterLeft cached leftover assets.');
			}
		}

		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		openfl.Assets.cache.clear("songs");
		#end

		var cache:haxe.ds.Map<String, FlxGraphic> = cast Reflect.field(FlxG.bitmap, "_cache");
		for (key => graphic in cache)
		{
			if (key.indexOf("text") == 0 && graphic.useCount <= 0)
			{
				FlxG.bitmap.remove(graphic);
			}
		}
	}

	static public var currentModDirectory:String = null;
	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (openfl.Assets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (openfl.Assets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static public function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, ?library:String, type:AssetType = TEXT)
	{
		return getPath(file, type, library);
	}

	// Não utilizado mas preguiça né?
	inline static public function lua(key:String, ?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return returnSound(key, 'sounds', key, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return returnSound(key, key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return returnSound(key, 'music', key, library);
	}

	inline static public function voices(song:String):Any
	{
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Voices.$SOUND_EXT';
		#else
		var songKey:String = '${formatToSongPath(song)}/Voices';
		var voices = returnSound(song, 'songs', songKey);
		return voices;
		#end
	}

	inline static public function inst(song:String):Any
	{
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Inst.$SOUND_EXT';
		#else
		var songKey:String = '${formatToSongPath(song)}/Inst';
		var inst = returnSound(song, 'songs', songKey);
		return inst;
		#end
	}

	inline static public function video(key:String, ?library:String)
	{
		#if desktop
		trace('assets/videos/$key.mp4');
		return getPath('videos/$key.mp4', BINARY, library);
		#elseif mobile
		trace(getPath('videos/$key', BINARY, library));
		return 'assets/videos/$key'; // Verificar se precisa adicionar o .html no final
		#end
	}

	inline static public function imagechecker(key:String, ?library:String):Dynamic
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace(' ', '-');
	}

	inline static public function image(key:String, ?library:String, canGPU:Bool = true):FlxGraphic
	{ // canGPU serve pra evitar um erro MUITO CRÍTICO em FlxTiledSprite
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		var returnAsset:FlxGraphic = returnGraphic(key, library, gpu);
		return returnAsset;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, canGPU:Bool = true)
	{
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String, canGPU:Bool = true)
	{
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	public static function returnGraphic(key:String, ?library:String, gpu:Bool)
	{
		var path:String = '';

		path = getPath('images/$key.png', IMAGE, library);

		trace('Imagem carregada: $key.png');
		if (openfl.Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(key))
			{
				var bitmap:BitmapData = openfl.Assets.getBitmapData(path, false);
				var graphic:FlxGraphic = null;

				if (gpu)
				{
					var texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, false, 0);
					texture.uploadFromBitmapData(bitmap);
					currentTrackedTextures.set(key, texture);
					bitmap.disposeImage();
					FlxDestroyUtil.dispose(bitmap);
					bitmap = null;
					graphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, key);
				}
				else
					graphic = FlxGraphic.fromBitmapData(bitmap, false, key, false);

				graphic.persist = true;
				currentTrackedAssets.set(key, graphic);
			}
			/*else
				trace('Carregando do cache existente: $key'); */

			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}

		trace('Could not find image at path $path');
		FlxG.log.error('Could not find image at path $path');
		return null; // Apenas para garantir que o jooj tentará carregar do jeito normal primeiro (ou então ajuidar a descobrir qual o pilantra.)
	}

	public static function returnSound(key:String, path:String, file:String, ?library:String)
	{
		// I hate this so god damn much
		// Eu também passei a odiar meu caro colega nordestino :fist::pensive:

		var gottenPath:String = getPath('$path/$file.$SOUND_EXT', SOUND, library);
		var folder:String = '';

		if (path == 'songs')
			folder = 'songs:';

		var address:String = folder + gottenPath;

		trace('Som carregado: $file.$SOUND_EXT');

		if (openfl.Assets.exists(address, SOUND))
		{
			if (!currentTrackedSounds_cacheID.exists(key))
			{
				currentTrackedSounds_cacheID.set(key, address);
				currentTrackedSounds.set(address, openfl.Assets.getSound(address));
			}
		}
		else
			FlxG.log.error('Could not find sound at ${address}');

		localTrackedAssets.push(address);
		return currentTrackedSounds.get(address);
	}
}
