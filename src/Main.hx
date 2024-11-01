package;

import flixel.FlxGame;
import game.states.Init;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import lime.app.Application;
import objects.FPS;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;

using StringTools;

#if desktop
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Sprite
{
	public static var fpsVar:FPS;

	public static var isKeyboard:Bool = true;
	public static var mouse_allowed:Bool = false;
	#if mobile
	private static var touch_allowed:Bool = true;
	public static var path = lime.system.System.applicationStorageDirectory;
	// Essa commit é quase inteira baseada numa PR feita no port da FE para android
	// https://github.com/musk-h/forever-engine-android-port/pull/1
	// Só troquei a lógica trocando a var de dentro do HSys (no meu caso, o Utils) e movendo pro Main.
	#end

	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: Init, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	public static function mouseVisibility(visible:Bool):Void
	{
		#if desktop
		FlxG.mouse.visible = visible;
		#else
		touch_allowed = visible;
		#end
	}

	public static function getMouseVisibility():Bool
	{
		#if desktop
		return FlxG.mouse.visible;
		#else
		return touch_allowed;
		#end
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
		
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if (fpsVar != null)
			fpsVar.visible = SaveData.showFPS;

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		
		var shaderarray:Array<openfl.filters.BitmapFilter> = [new openfl.filters.ColorMatrixFilter(SaveData.shaderMatrix)];
		if (SaveData.shaderMatrix.length != 0)
		{
			FlxG.game.setFilters(shaderarray); // Resumindo: Se tu quer enxergar as cores certinhas, tu vai ter lag no jogo k
		}
		setFPSCap(SaveData.fps);
		backend.LanguageManager.checkandset();
		#if mobile
		AssetsManager.list(); // colocando o .list() aqui pra já deixar a lista configurada.
		#end
		FlxG.fixedTimestep = false; // Agora eu fiquei na dúvida entre deixar isso falso, ou deixar isso como verdadeiro.
		// Eu mandei lá no Discord, uma gravação onde o FPS Cap é 240 e ele fica SUPER lagado. Só consegui resolver isso deixando o timestep como falso.
	}

	public static function setFPSCap(cap:Int)
	{
		if (cap > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = cap;
			FlxG.drawFramerate = cap;
		} else {
			FlxG.drawFramerate = cap;
			FlxG.updateFramerate = cap;
		}
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		#if desktop
		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";
		#end

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nErro do crash: " + e.error;

		#if desktop
		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");
		#end

		Sys.println(errMsg);

		#if desktop
		Sys.println("Crash dump saved in " + Path.normalize(path));
		#end

		Application.current.window.alert(errMsg, "Erro!");
		Sys.exit(1);
	}
}
