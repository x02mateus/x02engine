package backend;

import flash.media.Sound;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxDestroyUtil;
import lime.utils.Assets;
import objects.FPS;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

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
	public static final limites:Array<Int> = [500, 600, 700]; //Esperança para 1gb de RAM, mas tenho certeza que isso não será suficiente para Love n' Funkin, Libitina e outras pesadonas.

	public static var dumpExclusions:Array<String> = [];

	public static function excludeAsset(key:String):Void {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static function clear_memory_by_key(key:String, remove_local_mem:Bool = false){
		if (currentTrackedAssets.exists(key) && !dumpExclusions.contains(key)){
			trace('removendo');
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
				OpenFlAssets.cache.removeBitmapData(key);
				OpenFlAssets.cache.clearBitmapData(key);
				OpenFlAssets.cache.clear(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
				FlxDestroyUtil.dispose(obj.bitmap);
				currentTrackedAssets.remove(key);
			}
		}else if (currentTrackedSounds_cacheID.exists(key)){
			var sound_id:String = currentTrackedSounds_cacheID.get(key);
			currentTrackedSounds_cacheID.remove(key);
			OpenFlAssets.cache.removeSound(sound_id);
			OpenFlAssets.cache.clearSounds(sound_id);
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
			for (key in OpenFlAssets.cache.getKeys())
			{
				if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
				{
					OpenFlAssets.cache.clear(key);
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

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
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

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return returnSound('sounds', key, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return returnSound('music', key, library, true);
	}

	inline static public function voices(song:String):Any
	{
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Voices.$SOUND_EXT';
		#else
		var songKey:String = '${formatToSongPath(song)}/Voices';
		var voices = returnSound('songs', songKey);
		return voices;
		#end	}

	inline static public function inst(song:String):Any
	{
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Inst.$SOUND_EXT';
		#else
		var songKey:String = '${formatToSongPath(song)}/Inst';
		var inst = returnSound('songs', songKey, true);
		return inst;
		#end
	}

	inline static public function imagechecker(key:String, ?library:String):Dynamic
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function image(key:String, ?library:String, canGPU:Bool = false):FlxGraphic { //canGPU serve pra evitar um erro MUITO CRÍTICO em FlxTiledSprite
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		var returnAsset:FlxGraphic = returnGraphic(key, library, gpu);
		return returnAsset;
	}
	
	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{		
		if(OpenFlAssets.exists(Paths.getPath(key, type))) {
			return true;
		}
		return false;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, canGPU:Bool = false)
	{
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		return FlxAtlasFrames.fromSparrow(image(key, library, gpu), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String, canGPU:Bool = false)
	{
		var gpu:Bool = false;
		if (canGPU)
			gpu = SaveData.gpu;
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library, gpu), file('images/$key.txt', library));
	}

	inline static public function formatToSongPath(path:String) {
		return path.toLowerCase().replace(' ', '-');
	}
	public static function returnGraphic(key:String, ?library:String, usarGPU:Bool = false) {
		var path:String = '';

		path = getPath('images/$key.png', IMAGE, library);

		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(key))
			{
				var bitmap:BitmapData = OpenFlAssets.getBitmapData(path, false);
				var graphic:FlxGraphic = null;

				FPS.curMemChecker();

				if (usarGPU || currentTrackedTextures.exists(path) || FPS.curMEMforReference > limites[SaveData.curPreset] ^ 2) {
					// Decidi alterar um pouco a lógica disso já que os limites e os presets vão ser automáticamente setados assim que tu entrar no jogo
					// Basicamente, se o uso da CPU chegar próximo do limite do aparelho, então a GPU será usada
					// É mais fácil gerenciar a GPU através da CPU do que o contrário.
					// Caso o jogo consuma mais do que um celular de 2gb pode aguenta,
					// Ele passa a usar GPU pra segurar o jooj por um pouco mais de tempo antes de precisar reiniciar o APK
					graphic = GPUManager.toGraphic(bitmap, key);
					trace('Imagem carregada por GPU: $key.png');
				} else {
					graphic = FlxGraphic.fromBitmapData(bitmap, false, key, false);
					#if (debug && !mobile)
					trace('carregando $key.png por CPU'); // Só tô mandando essa traces pra saber bem o que o jogo carrega durante a gameplay
					#end
				}
				

				graphic.persist = true;
				currentTrackedAssets.set(key, graphic);
			}
			/*else
				trace('Carregando do cache existente: $key');*/

			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}

		trace('Could not find image at path $path');
		FlxG.log.error('Could not find image at path $path');
		return null; //Apenas para garantir que o jooj tentará carregar do jeito normal primeiro (ou então ajuidar a descobrir qual o pilantra.)
	}

	public static function returnSound(path:String, key:String, ?library:String, stream:Bool = false) {
		var sound:Sound = null;
		var file:String = null;

		#if (debug && !mobile)
		trace('carregando $key.ogg por RAM/CPU'); // Só tô mandando essa traces pra saber bem o que o jogo carrega durante a gameplay
		#end

		// I hate this so god damn much
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		file = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (path == 'songs')
			gottenPath = 'songs:' + gottenPath;

		// trace(gottenPath);
		if (OpenFlAssets.exists(gottenPath, SOUND))
		{
			if (!currentTrackedSounds_cacheID.exists(key)){
				currentTrackedSounds_cacheID.set(key, gottenPath);
				currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(gottenPath));
			}
		}
		else
			FlxG.log.error('Could not find sound at ${gottenPath}');

		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
}