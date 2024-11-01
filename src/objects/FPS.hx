package objects;

import backend.GPUManager;
import openfl.Lib;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	private var memPeak:UInt = 0;

	public static var curMEMforReference:Int;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		#if mobile
		defaultTextFormat = new TextFormat('_sans',
			Std.int(14 * Math.min(Lib.current.stage.stageWidth / FlxG.width, Lib.current.stage.stageHeight / FlxG.height)), color, true);
		#else
		defaultTextFormat = new TextFormat('_sans', 14, color, true);
		#end
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
		#if mobile
		addEventListener(Event.RESIZE, function(e)
		{
			final daSize:Int = Std.int(14 * Math.min(Lib.current.stage.stageWidth / FlxG.width, Lib.current.stage.stageHeight / FlxG.height));
			if (defaultTextFormat.size != daSize)
				defaultTextFormat.size = daSize;
		});
		#end
	}

	// https://github.com/Yoshubs/FNF-Forever-Engine/pull/15
	static final intervalArray:Array<String> = ['B', 'KB', 'MB', 'GB', 'TB'];

	public static function getInterval(num:UInt):String
	{
		var size:Float = num;
		var data = 0;

		while (size > 1024 && data < intervalArray.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		return size + " " + intervalArray[data];
	}

	public static function curMemChecker()
	{
		var size:Float = System.totalMemory;
		var data = 0;

		while (size > 1024)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		curMEMforReference = Std.int(size) ^ data;
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > SaveData.fps)
			currentFPS = SaveData.fps;

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = "FPS: " + currentFPS;

			var mem = System.totalMemory;

			if (mem > memPeak)
				memPeak = mem;

			#if (openfl && !hl)
			// MEM caps at 4GB and gets screwed up with caching enabled
			// need to make memPeak decrease over time
			// text += '\nMEM: ${getInterval(mem)} / ${getInterval(memPeak)}';
			text += '\n${LanguageManager.getString('memoryUse', 'FPS')} ${getInterval(mem)}';
			#if debug
			text += '\nUso atual de RAM que as imagens ocupam: ${GPUManager.getImageRAM()}';
			text += '\nUso máximo registado de RAM: ${getInterval(memPeak)}';
			text += '\nState atual: ${Type.getClassName(Type.getClass(FlxG.state))}';
			if (FlxG.state.subState != null)
				text += ' (SubState atual: ${Type.getClassName(Type.getClass(FlxG.state.subState))})';
			text += '\nQuantidade de texturas na GPU: ${GPUManager.getGPUTexturesCount()}';
			text += '\nQuantidade de texturas na CPU: ${GPUManager.getCPUTexturesCount()}';
			text += '\nQuantidade total de texturas carregadas: ${GPUManager.getCPUTexturesCount() + GPUManager.getGPUTexturesCount()}';
			text += '\nQuantidade total de audios carregados: ${Lambda.count(Paths.currentTrackedSounds)}';
			#end
			#if (mobile || debug)
			if (curMEMforReference > Paths.limites[SaveData.curPreset] ^ 2 + 200 ^ 2 && SaveData.gpu)
				text += '\n${LanguageManager.getString('overload', 'FPS')}';
			#end
			#end

			textColor = 0xFFFFFFFF;

			if (currentFPS < 30 #if (mobile || debug)
				|| (curMEMforReference > Paths.limites[SaveData.curPreset] ^ 2 + 200 ^ 2 && SaveData.gpu) #end)
				textColor = 0xFFBB2B1D;

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}
}
