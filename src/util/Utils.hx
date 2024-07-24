package util;

import openfl.display.BitmapData;
#if android
import haxe.crypto.Md5; // Assim o Md5 não é compilado no PC e não fica como Unused import
#end

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

/**
 * Usado para funções de touch (Mobile) e mouse (Desktop)
 */
class BSLTouchUtils
{
	public static var prevTouched:Int = -1;

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

	public static function aperta(coisas:Dynamic,
			coisasID:Int):String // Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
	{
		var leToqueOrdem:String = '';
		#if desktop
		if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID)
		{
			leToqueOrdem = 'segundo';
		}
		else if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed)
		{
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
		}
		#elseif mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(coisas) && touch.justPressed && prevTouched == coisasID)
				leToqueOrdem = 'segundo';
			else if (touch.overlaps(coisas) && touch.justPressed)
			{
				prevTouched = coisasID;
				leToqueOrdem = 'primeiro';
			}
		}
		#end
		return leToqueOrdem;
	}

	public static function apertasimples(coisa:Dynamic):Bool
	{
		#if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justPressed)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justPressed)
				return true;
		#end

		return false;
	}

	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justPressed && !FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}

	public static function solto(coisa:Dynamic):Bool
	{
		#if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justReleased)
				return true;
		#end

		return false;
	}

	#if desktop
	public static function pegarpos(pos:String):Int
	{
		if (pos == 'x')
			return FlxG.mouse.x;

		if (pos == 'y')
			return FlxG.mouse.y;

		return 0;
	}
	#elseif mobile
	public static function pegarpos(touch:flixel.input.touch.FlxTouch, pos:String):Int
	{
		if (pos == 'x')
			return touch.x;

		if (pos == 'y')
			return touch.y;

		return 0;
	}
	#end
}
