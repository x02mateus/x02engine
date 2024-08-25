package util;

import flixel.graphics.FlxGraphic;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxAxes;
import openfl.display.BitmapData;
#if android
import haxe.crypto.Md5; // Assim o Md5 não é compilado no PC e não fica como Unused import

#end
enum InputDevices // Lista com todos os tipos de controle que esperamos que alguém vá usar, sentimos muito se você tem um amazon luna ou então um OUYA ou sei lá mais o que existe por ai.
{
	Keyboard;
	PS4_Controller;
	Switch_Controller;
	Xinput_Controller;
	AUTO;
}

/**
 * Usada pra usar a mesma função pra plataformas diferentes (Mobile e Android)
 */
class Utils
{
	// X02 NESCESSITAMOS DESCRIÇÃO URGENTEMENTE, EU NÃO SEI O QUE ESSA FUNÇÃO FAZ OMAGAAAAAAAAAA :fist::pensive:
	public static function clearArray(arr:Array<Dynamic>) // Usado pois não gosto da hitbox do Saw, mas to com preguiça de mudar a forma como as hitbox funcionam...
	{
		#if cpp
		arr.splice(0, arr.length);
		#else
		untyped arr.length = 0;
		#end
	}

	/**
	 * Lê o conteúdo de um arquivo.
	 * @param id Arquivo que será lido pela função
	 */
	public static function getContent(id:String):String
	{
		#if mobile
		return Assets.getText(id);
		#else
		return File.getContent(id);
		#end
	}

	/**
	 * Retorna entre verdadeiro ou falso a existência do arquivo especificado
	 * @param id Arquivo para verificação
	 */
	public static function exists(id:String):Bool
	{
		#if mobile
		return Assets.exists(id);
		#else
		return FileSystem.exists(id);
		#end
	}

	/**
	 * Lê um arquivo binário (Eu acho :skull:)
	 * @param id Arquivo que será lido pela função
	 */
	public static function getBytes(id:String)
	{
		#if mobile
		return Assets.getBytes(id);
		#else
		return File.getBytes(id);
		#end
	}

	/**
	 * Retorna o nome de todos os arquivos dentro do diretório especificado
	 * @param id Diretório que será lido
	 */
	public static function readDirectory(library:String):Array<String>
	{
		#if mobile
		var something:Array<String> = [];
		var bruh = Assets.list();
		for (folder in bruh.filter(text -> text.contains('$library')))
		{
			if (!folder.startsWith('.'))
				something.push(folder);
		}
		return something;
		#else
		return FileSystem.readDirectory(library);
		#end
	}

	/**
	 * Cria um novo BitmapData de um arquivo.
	 * @param id Arquivo que será usado pra criar o Bitmap
	 */
	public static function fromFile(id:String)
	{
		#if mobile
		return openfl.Assets.getBitmapData(id);
		#else
		return BitmapData.fromFile(id);
		#end
	}

	/**
	 * Copia o conteúdo de uma string para o seu histórico do CTRL + C (PC) ou pro teclado (Mobile)
	 * @param id String que será copiada
	 */
	public static function copiarclipboard(coisa:String)
	{
		openfl.system.System.setClipboard(coisa.trim());
	}
}

class CoolUtil
{
	// [Difficulty name, Chart file suffix]
	public static var difficultyStuff:Array<Dynamic> = [
		['Easy', '-easy'],
		['Normal', ''],
		['Hard', '-hard']
	];

	/*public static function difficultyString():String
	{
		return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
	}*/

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a do Math. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function seno(n:Float):Float
	{
		return FlxMath.fastSin(n);
	}

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a da classe 'Math'. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function cosseno(n:Float):Float
	{
		return FlxMath.fastCos(n);
	}

	/**
	 * Uma função que retorna um número aproximado de pi.
	 * @return Float (Math.PI)
	 */
	inline public static function pi():Float
	{
		return Math.PI;
	}

	// Não sei o que isso faz
	inline public static function formatScore(zeros_vezes:Int, num_vezes:Int):String
	{
		var zeros:String = repeat("0",
			zeros_vezes - (Std.int(Math.log(num_vezes) / Math.log(10)) + 1)); // Maldito haxe que não tem função log10 já imbutida :skull:
		var num:String = Std.string(num_vezes);

		return zeros + num;
	}

	// Não sei o que isso faz
	inline public static function repeat(str:String, times:Int):String
	{
		var result:String = "";
		for (i in 0...times)
			result += str;
		return result;
	}

	// Não sei o que isso faz
	public static function mathClamp(n:Float, min:Float, max:Float):Int
	{
		return Std.int(Math.min(Math.max(n, min), max));
	}

	/**
	 * Formata um texto deixando ele bonitinho (Letras maíusculas e minúsculas)
	 * @param text O texto que você vai capitalizar. (nem sei se essa palavra existe pra ser bem sincero)
	 */
	inline public static function capitalize(text:String)
	{
		return text.charAt(0).toUpperCase() + text.substr(1);
	}

	/**
	 * Retorna uma cor de uma String.
	 * @param color A cor em formato de String. 
	 * @return Retorna um FlxColor.
	 */
	inline public static function colorFromString(color:String):FlxColor // Já estava ficando deveras pito com isso...
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null)
			colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	// Não sei o que isso faz
	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}

	/**
	 * Carrega um arquivo de Texto (pode carregar outros arquivos também, mas o foco principal são arquivos .txt)
	 * @param path Caminho do seu arquivo
	 * @return Retorna uma Array<String> que contém o seu texto.
	 */
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if (Assets.exists(path))
			daList = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	/**
	 * Transforma uma String em Array usando o método .split para criar linebreaks.
	 * @param string A String que será utilizada para criar a lista.
	 * @return Retorna uma lista (Array<String>) com as linhas da Array separadas.
	 */
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	// Não sei o que isso faz
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	/**
	 * Cria uma Array de números
	 * @param max O número máximo que sua Array terá. 
	 * @param min O número mínimo que sua Array terá. (Já é 0 por padrão.)
	 * @return Array completa com números entre min e max
	 */
	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// Não sei pra que isso serve, então aqui não tem explicação
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/**
	 * Abre um URL.
	 * @param URL do Site que você deseja abrir.
	 */
	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/**
	 * Retorna o path da Savedata do jogo (Compatível com as versões antigas e novas do Flixel.)
	 * @return Path da Savedata
	 */
	public static function getSavePath():String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") 'mateusx02' #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public static function flash(duration:Float)
	{
		FlxG.camera.flash(0x2E236C, duration);
	}
}

/**
 * Serve para fazer o swipe em objetos na tela.
 */
// Não sei para que servem os parâmetros

class SpriteSwapper extends FlxSprite
{
	public var target:Int;
	public var tweenController:FlxTween;

	private var spaceBetween:Int;

	public var tweenTimer:Float = 0.5;

	private var activeAxis:FlxAxes;
	private final num_objects:Int;
	private final objectsList:Int;

	public var specialOffset:Float = 0;

	public function new(target:Int, sprite:FlxGraphic, objects_on_screen:Int = 1, space_between:Int = 1, swipe_axis:FlxAxes = X, size_mult:Float = 1,
			objects_in_list = 1)
	{
		this.num_objects = objects_on_screen - 1;
		this.objectsList = objects_in_list;
		if (num_objects < 1)
			num_objects = 1; // nope, isso não nescessariamente representa o numero de objetos na tela
		// Ou representa se você contar o ZERO

		super(0, 0);
		this.spaceBetween = space_between;
		this.activeAxis = swipe_axis;

		this.loadGraphic(sprite);
		this.setTarget(target);
		if (activeAxis == X)
		{
			this.setGraphicSize(Std.int(FlxG.width / num_objects * size_mult));
			this.setPosition(((FlxG.width / this.num_objects) * this.target - this.width) / 2 + this.target * this.spaceBetween, 0);
			this.screenCenter(Y);
		}
		else if (activeAxis == Y)
		{
			this.setGraphicSize(Std.int(FlxG.height / num_objects * size_mult));
			this.setPosition(0, (FlxG.height / this.num_objects * this.target - this.height) / 2 + this.target * this.spaceBetween);
			this.screenCenter(X);
		}
	}

	public function checkTween():Void
	{
		if (tweenController != null)
			tweenController.cancel();
	}

	public function updateTarget(manual:Bool = false):Void
	{
		this.checkTween();

		if (activeAxis == X)
		{
			if (!manual)
				this.setTarget(Math.round((2 * this.x + this.width) / ((FlxG.width / num_objects) + 2 * this.spaceBetween)));

			tweenController = FlxTween.tween(this, {x: (FlxG.width / num_objects * target - this.width) / 2 + target * this.spaceBetween + specialOffset},
				tweenTimer, {
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						tweenController = null;
					}
				});
		}
		else if (activeAxis == Y)
		{
			if (!manual)
				this.setTarget(Math.round((2 * this.y + this.height) / ((FlxG.height / num_objects) + 2 * this.spaceBetween)));
			tweenController = FlxTween.tween(this, {y: (FlxG.height / num_objects * target - this.height) / 2 + target * this.spaceBetween + specialOffset},
				tweenTimer, {
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						tweenController = null;
					}
				});
		}
	}

	public inline function getTarget():Int
	{
		return this.target;
	}

	public function setTarget(target):Void
	{
		this.target = target; // usa isso pra trocar fazer o scroll
		this.visible = Math.abs(this.target) <= 4;
		if (this.target <= -5)
		{
			this.target += this.objectsList;
		}
		else if (this.target > this.objectsList - 5)
		{
			this.target -= this.objectsList;
		}
	}
}

/**
 * Usado para funções de touch (Mobile) e mouse (Desktop)
 */
class BSLTouchUtils
{
	// Code por Matheus Silver e Lorena provavelmente
	public static var prevTouched:Int = -1;

	/**
	 * Retorna verdadeiro ou falso caso você dê um Toque na tela (Mobile) ou aperte o botão do Mouse (Desktop)
	 */
	public static function justTouched():Bool // Copiado do Hsys k
	{
		#if (flixel && android)
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}

		return justTouched;
		#else
		return FlxG.mouse.justPressed; // Isso aqui é mais válido pro modboa mas né?
		#end
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop).
	 */
	public static function touched():Bool
	{
		#if (flixel && android)
		var touched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.pressed)
				touched = true;
		}

		return touched;
		#else
		return FlxG.mouse.pressed;
		#end
	}

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop).
	 */
	public static function justSolto():Bool
	{
		#if (flixel && android)
		var justReleased:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justReleased)
				justReleased = true;
		}

		return justReleased;
		#else
		return FlxG.mouse.justReleased;
		#end
	}

	/**
	 * Função para tocar em uma coisa duas vezes para poder realmente selecionar ele
	 * @param coisas As coisas uai
	 * @param coisasID Socorro Silvio nunca entendi como sua função (ou função da Lorena 🤔) funciona
	 */
	public static function aperta(coisas:Dynamic,
			coisasID:Int):String // Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
	{
		var leToqueOrdem:String = '';
		#if desktop
		if (over(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID)
		{
			leToqueOrdem = 'segundo';
		}
		else if (over(coisas) && FlxG.mouse.justPressed)
		{
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
		}
		#elseif mobile
		for (touch in FlxG.touches.list)
		{
			if (over(coisas) && touch.justPressed && prevTouched == coisasID)
				leToqueOrdem = 'segundo';
			else if (over(coisas) && touch.justPressed)
			{
				prevTouched = coisasID;
				leToqueOrdem = 'primeiro';
			}
		}
		#end
		return leToqueOrdem;
	}

	/**
	 * Retorna verdadeiro ou falso caso você tenha apertado um objeto
	 * @param coisa Texto, sprite ou qualquer coisa que será apertada
	 */
	public static function apertasimples(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justPressed)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso o touch (Mobile) ou cursor (Desktop) sobreponha um objeto
	 * @param coisa ..a coisa uai
	 */
	public static function over(coisa:Dynamic):Bool
	{
		#if desktop
		if (!Main.getMouseVisibility())
			return false; // Provavelmente a única coisa que faz o BSLTouchUtils se pagar no ModBoa.
		return FlxG.mouse.overlaps(coisa);
		#elseif mobile
		for (touch in FlxG.touches.list)
			return touch.overlaps(coisa);
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		return (over(coisa) && FlxG.mouse.pressed);
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function solto(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justReleased)
				return true;
		#end

		return false;
	}

	// Adaptação para um code bem antigo do ytb music
	public static function justsolto():Bool
	{
		#if desktop
		return FlxG.mouse.justReleased;
		#elseif mobile
		for (touch in FlxG.touches.list)
			return touch.justReleased;
		#end

		return false;
	}

	#if desktop
	/**
	 * Retorna uma int da posição atual do seu mouse
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
	public static function pegarpos(pos:String):Int
	{
		if (pos == 'x')
			return FlxG.mouse.x;

		if (pos == 'y')
			return FlxG.mouse.y;

		return 0;
	}

	#elseif mobile
	/**
	 * Retorna uma int da posição atual do seu toque
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
	public static function pegarpos(pos:String):Int
	{
		for (touch in FlxG.touches.list)
		{
			if (pos == 'x')
				return touch.x;

			if (pos == 'y')
				return touch.y;
		}
		return 0;
	}
	#end

	public static function teclado(acao:String)
	{ // Converter para lua
		#if mobile
		if (acao == "abrir")
		{
			FlxG.stage.window.textInputEnabled = true;
		}
		else if (acao == "fechar")
		{
			FlxG.stage.window.textInputEnabled = false;
		}
		#else
		trace("Abrir/fechar teclado e uma funcao exclusiva do mobile.");
		#end
	}
}

/**
 * Usado para o Deslize na Tela (Mobile) e Scroll do Mouse (Desktop)
 */
class BSLSwipeUtils
{
	public static var scrollSpeed:Float = 0;
	public static final scrollAcceleration:Float = 1;
	public static final maxScrollSpeed:Float = 10.0;
	public static var mouseScrollMultiplier:Int = 1;

	public static var scrollX:Int = 0;
	public static var scrollY:Int = 0;

	public static var prevTouchX:Int = 0;
	public static var prevTouchY:Int = 0;

	public static var max_y:Int = 1;
	public static var max_x:Int = 1;

	private static var touchY:Int;
	private static var touchX:Int;

	public static var is_swipping:Bool = false;
	public static var reset_manual = false;

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	// foi o que eu entendi da função pelo menos
	public static function swipeHorizontal():Void
	{
		#if mobile
		if (BSLTouchUtils.justTouched())
		{
			prevTouchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
		} // Captura a posição inicial do toque.
		else if (BSLTouchUtils.touched())
		{
			touchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
			var deltaX:Int = (touchX - prevTouchX); // k

			scrollX = deltaX;

			prevTouchX = touchX;
		} // Enquanto está segurando, calcula o deslocamento da posição inicial do toque e a velocidade do deslocamento
		// Válido apenas para toque na tela.
		else
		#end if (Math.abs(scrollX) > 0)
	{
			if (scrollX > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollX < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(Utils.CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
	}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollX += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollX += Std.int(scrollSpeed);
		scrollX = Utils.CoolUtil.mathClamp(scrollX, -FlxG.width / max_x, FlxG.width / max_x);
		if (Math.abs(scrollX) <= Math.abs(scrollSpeed))
			resetScrolls();
		else
			is_swipping = true;
	}

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	public static function swipeVertical():Void
	{
		#if mobile
		if (BSLTouchUtils.justTouched())
		{
			prevTouchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
		}
		else if (BSLTouchUtils.touched())
		{
			touchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
			var deltaY:Int = (touchY - prevTouchY);

			scrollY = deltaY;

			prevTouchY = touchY;
		}
		else
		#end if (Math.abs(scrollY) > 0)
	{
			if (scrollY > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollY < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(Utils.CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
	}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollY += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollY += Std.int(scrollSpeed);
		scrollY = Utils.CoolUtil.mathClamp(scrollY, -FlxG.height / max_y, FlxG.height / max_y);
		if (Math.abs(scrollY) <= Math.abs(scrollSpeed))
			resetScrolls();
		else
			is_swipping = true;
	}

	inline public static function resetScrolls():Void
	{
		scrollX = scrollY = 0;
		scrollSpeed = 0;
		if (!reset_manual)
			is_swipping = false;
	}
}

class InputFormatter
{
	public static function getKeyNameGamepad(key:FlxGamepadInputID):String
	{
		switch (key)
		{
			case DPAD_LEFT:
				return "dpad_left";
			case DPAD_RIGHT:
				return "dpad_right";
			case DPAD_UP:
				return "dpad_up";
			case DPAD_DOWN:
				return "dpad_down";
			case BACK:
				return "select";
			case START:
				return "start";
			case A:
				return "button_down";
			case B:
				return "button_right";
			case X:
				return "button_left";
			case Y:
				return "button_up";
			case GUIDE:
				return "guide";
			case LEFT_SHOULDER:
				return "l1";
			case LEFT_TRIGGER:
				return "l2";
			case RIGHT_SHOULDER:
				return "r1";
			case RIGHT_TRIGGER:
				return "r2";
			case LEFT_STICK_DIGITAL_DOWN:
				return "left_ana_down"; // TU NÃO ACHO QUE EU IA ESCREVER OUTRA COISA AQUI NÉ?
			case LEFT_STICK_DIGITAL_UP:
				return "left_ana_up";
			case LEFT_STICK_DIGITAL_RIGHT:
				return "left_ana_right";
			case LEFT_STICK_DIGITAL_LEFT:
				return "left_ana_left";
			case RIGHT_STICK_DIGITAL_DOWN:
				return "right_ana_down";
			case RIGHT_STICK_DIGITAL_UP:
				return "right_ana_up";
			case RIGHT_STICK_DIGITAL_RIGHT:
				return "right_ana_right";
			case RIGHT_STICK_DIGITAL_LEFT:
				return "right_ana_left";
			case RIGHT_STICK_CLICK:
				return "right_ana_click";
			case LEFT_STICK_CLICK:
				return "left_ana_click";
			case NONE:
				return '---'; // A.K.A. o que tu tá fazendo com teu controle mano?

			default:
				var label:String = '' + key;
				if (label.toLowerCase() == 'null')
					return '---';
				return '' + label.charAt(0).toUpperCase() + label.substr(1).toLowerCase();
		}
	}

	public static function getKeyName(key:FlxKey):String
	{
		switch (key)
		{
			case BACKSPACE:
				return "bckspc";
			case ENTER:
				return "enter";
			case CONTROL:
				return "ctrl";
			case ALT:
				return "alt";
			case CAPSLOCK:
				return "caps";
			case INSERT:
				return "insert";
			case END:
				return "end";
			case PAGEUP:
				return "pgup";
			case PAGEDOWN:
				return "pgdown";
			case ZERO | NUMPADZERO:
				return "0";
			case ONE | NUMPADONE:
				return "1";
			case TWO | NUMPADTWO:
				return "2";
			case THREE | NUMPADTHREE:
				return "3";
			case FOUR | NUMPADFOUR:
				return "4";
			case FIVE | NUMPADFIVE:
				return "5";
			case SIX | NUMPADSIX:
				return "6";
			case SEVEN | NUMPADSEVEN:
				return "7";
			case EIGHT | NUMPADEIGHT:
				return "8";
			case NINE | NUMPADNINE:
				return "9";
			case F1:
				return "f1";
			case F2:
				return "f2";
			case F3:
				return "f3";
			case F4:
				return "f4";
			case F5:
				return "f5";
			case F6:
				return "f6";
			case F7:
				return "f7";
			case F8:
				return "f8";
			case F9:
				return "f9";
			case F10:
				return "f10";
			case F11:
				return "f11";
			case F12:
				return "f12";
			case SHIFT:
				return "shift";
			case SPACE:
				return "space";
			case NUMPADMULTIPLY:
				return "multiply";
			case TAB:
				return "tab";
			case NUMPADPLUS | PLUS:
				return "plus";
			case NUMPADMINUS | MINUS:
				return "minus";
			case SEMICOLON:
				return ";";
			case COMMA:
				return "less";
			case PERIOD:
				return "more";
			// case SLASH:
			//	return "/";
			case DELETE:
				return "del";
			case ESCAPE:
				return "escape";
			case HOME:
				return "homem";
			case LBRACKET:
				return "[";
			case BACKSLASH:
				return "backslash";
			case RBRACKET:
				return "]";
			case QUOTE:
				return "quote";
			case PRINTSCREEN:
				return "prtscrn";
			case NONE:
				return '---';
			default:
				var label:String = '' + key;
				if (label.toLowerCase() == 'null')
					return '---';
				return '' + label.charAt(0).toUpperCase() + label.substr(1).toLowerCase();
		}
	}
}

class GamepadUtil
{
	private static final bindsBlackList:Map<InputDevices, Array<Int>> = [Switch_Controller => [-1], PS4_Controller => [-1], Xinput_Controller => [-1, 10]];

	inline public static function formatKey(inputData:Dynamic):String
	{
		if (Main.isKeyboard)
			return InputFormatter.getKeyName(inputData);
		else
			return InputFormatter.getKeyNameGamepad(inputData);
	}

	public static function isValidInput(keyPressed:Int, gamepadModel:InputDevices):Bool
	{
		return !bindsBlackList.get(gamepadModel).contains(keyPressed);
	}

	inline public static function getActualGamepadModel():InputDevices
	{
		switch (FlxG.gamepads.lastActive.detectedModel)
		{
			case SWITCH_PRO:
				return Switch_Controller;
			case PS4:
				return PS4_Controller;
			default:
				return Xinput_Controller;
		}
	}

	inline public static function getDisplayGamepadModel():InputDevices
	{
		if (Main.isKeyboard)
			return Keyboard;
		else if (SaveData.gamepadDisplay == AUTO)
			return getActualGamepadModel();
		else
			return SaveData.gamepadDisplay;
	}

	inline public static function anyGamepadButtonPressed():Bool
	{
		return (FlxG.gamepads.anyButton() && isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel()));
	}

	inline public static function getGamepadPressedButton():Int
	{
		if (isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel()))
			return FlxG.gamepads.lastActive.firstJustPressedID();
		return -1; // Só pra poder padronizar como none.
	}

	inline public static function checkGamepadPressedButton(button:FlxGamepadInputID):Bool
	{
		return FlxG.gamepads.anyJustPressed(button);
	}

	inline public static function getGamepadConnected():Bool
	{
		return FlxG.gamepads.lastActive != null;
	}
}
