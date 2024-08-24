package game.states.options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();

	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";

	public final function getName()
	{
		return _name;
	}

	public function new(catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return throw "stub!";
	}

	private function updateDisplay():String
	{
		return throw "stub!";
	}

	public function getValue():String
	{
		return throw "stub!";
	}

	public function left():Bool
	{
		return throw "stub!";
	}

	public function right():Bool
	{
		return throw "stub!";
	}
}

class KeyBindingsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ConfiguracoesState.instance.openSubState(new game.states.options.KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Keybinds';
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.downscroll = !SaveData.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Downscroll ' + (SaveData.downscroll ? 'ativado' : 'desativado');
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.ghostTapping = !SaveData.ghostTapping;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Ghost Tapping' + (SaveData.ghostTapping ? ' ativado' : ' desativado');
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.flashing = !SaveData.flashing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Luzes piscantes' + ' ' + (SaveData.flashing ? 'ativadas' : 'desativadas');
	}
}

class Padroes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
        PresetsState.options = true;
		MusicBeatState.switchState(new PresetsState());
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Presets de otimização';
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.showFPS = !SaveData.showFPS;
		Main.fpsVar.visible = SaveData.showFPS;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Display de FPS/MEM' + ' ' + (SaveData.showFPS ? 'visível' : 'invisível');
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'FPS CAP';
	}

	override function right():Bool
	{
		SaveData.fps += 1;

		if (SaveData.fps < 30)
			SaveData.fps = 30;
		else if (SaveData.fps > 330)
			SaveData.fps = 330;

		FlxG.updateFramerate = SaveData.fps;
		FlxG.drawFramerate = SaveData.fps;

		return true;
	}

	override function left():Bool
	{
		SaveData.fps -= 1;

		if (SaveData.fps < 30)
			SaveData.fps = 30;
		else if (SaveData.fps > 330)
			SaveData.fps = 330;

		Main.setFPSCap(SaveData.fps);

		return true;
	}

	override function getValue():String
	{
		return 'FPS CAP' + ': ' + SaveData.fps;
	}
}

class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Velocidade do Scroll';
	}

	override function right():Bool
	{
		SaveData.scrollSpeed += 0.1;

		if (SaveData.scrollSpeed < 0.9)
			SaveData.scrollSpeed = 0.9;

		if (SaveData.scrollSpeed > 4)
			SaveData.scrollSpeed = 4;

		return true;
	}

	override function left():Bool
	{
		SaveData.scrollSpeed -= 0.1;

		if (SaveData.scrollSpeed < 0.9)
			SaveData.scrollSpeed = 0.9;

		if (SaveData.scrollSpeed > 4)
			SaveData.scrollSpeed = 4;

		return true;
	}

	override function getValue():String
	{
		var defaulttexto:String;
		defaulttexto = "Padrão da Música";
		var visualValue:String = SaveData.scrollSpeed < 1 ? '$defaulttexto' : Std.string(FlxMath.roundDecimal(SaveData.scrollSpeed, 1));
		return 'Velocidade do Scroll' + ': ' + visualValue;
	}
}

#if android
class HitboxSkin extends Option
{
    var count:Int = 0;
    var skins:Array<String> = ['normal', 'invisivel'];

	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Hitbox Skin';
	}

	override function right():Bool
	{
        count++;
        
        if(count < 0)
            count = skins.length - 1;
        if(count > skins.length - 1)
            count = 0;

        SaveData.hitboxSkin = skins[count];
        
		return true;
	}

	override function left():Bool
	{
		count--;
        
        if(count < 0)
            count = skins.length - 1;
        if(count > skins.length - 1)
            count = 0;

        SaveData.hitboxSkin = skins[count];

		return true;
	}

	override function getValue():String
	{
		return 'Skin da Hitbox: ' + SaveData.hitboxSkin;
	}
}
#end

class AntiAliasing extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.antialiasing = !SaveData.antialiasing;
		display = updateDisplay();

		for (member in game.states.options.ConfiguracoesState.instance.members)
		{
			var member:Dynamic = member;

			if (member != null && (member is FlxSprite || member is FlxText))
				member.antialiasing = SaveData.antialiasing;
		}

		return true;
	}

	private override function updateDisplay():String
	{
		return 'Antialiasing' + ' ' + (SaveData.antialiasing ? 'Ligado' : 'Desligado');
	}
}

class GPUTextures extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.gpu = !SaveData.gpu;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return (SaveData.gpu ? 'Carregar ' : 'Não carregar ') + 'texturas na GPU';
	}
}

class Hitsounds extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Hitsound';
	}

	override function right():Bool
	{
		SaveData.hitSound++;

		if (SaveData.hitSound < 0)
			SaveData.hitSound = 5;

		if (SaveData.hitSound > 5)
			SaveData.hitSound = 0;

		return true;
	}

	override function left():Bool
	{
		SaveData.hitSound--;

		if (SaveData.hitSound < 0)
			SaveData.hitSound = 5;

		if (SaveData.hitSound > 5)
			SaveData.hitSound = 0;

		return true;
	}

	override function getValue():String
	{
		var visualValue:String = SaveData.hitSound == 0 ? 'desativado' : 'tipo ${Std.string(SaveData.hitSound)}';
		return 'Hitsound ' + visualValue;
	}
}

class VolumeHitsounds extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Volume dos Hitsounds';
	}

	override function right():Bool
	{
        if(SaveData.hitSound != 0) {
            SaveData.hitSoundVolume += 0.1;

            if (SaveData.hitSoundVolume < 0)
                SaveData.hitSoundVolume = 0;

            if (SaveData.hitSoundVolume > 1)
                SaveData.hitSoundVolume = 1;
        }

		return true;
	}

	override function left():Bool
	{
		if(SaveData.hitSound != 0) {
            SaveData.hitSoundVolume -= 0.1;

            if (SaveData.hitSoundVolume < 0)
                SaveData.hitSoundVolume = 0;

            if (SaveData.hitSoundVolume > 1)
                SaveData.hitSoundVolume = 1;
        }

		return true;
	}

	override function getValue():String
	{
		var visualValue:String = SaveData.hitSoundVolume == 0 ? 'mutado' : ': ${Std.string(SaveData.hitSoundVolume)}';
		return 'Hitsound ' + visualValue;
	}
}

class TesteHitsounds extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
        FlxG.sound.play(Paths.sound('hitsounds/${SaveData.hitSound}', 'shared'), SaveData.hitSoundVolume);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Prévia dos Hitsounds';
	}
}

class MissSounds extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		SaveData.missSounds = !SaveData.missSounds;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return 'Sons de miss ' + (SaveData.missSounds ? 'ativados' : 'desativados');
	}
}

class Daltonismo extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Filtro de Daltonismo';
	}

    private function getFilterType(filter:Int):String {
        switch(filter) {
			case 1: return "Deuteranopia";
			case 2: return "Tritanopia";
			case 3: return "Protanopia";
			default: return "Sem filtro";
		}
    }

	override function right():Bool
	{
		SaveData.curFilter++;

		if (SaveData.curFilter < 0)
			SaveData.curFilter = 3;

		if (SaveData.curFilter > 3)
			SaveData.curFilter = 0;

        ConfiguracoesState.changeFilter(SaveData.curFilter);

		return true;
	}

	override function left():Bool
	{
		SaveData.curFilter--;

		if (SaveData.curFilter < 0)
			SaveData.curFilter = 3;

		if (SaveData.curFilter > 3)
			SaveData.curFilter = 0;

        ConfiguracoesState.changeFilter(SaveData.curFilter);

		return true;
	}

	override function getValue():String
	{
		var visualValue:String = ': ${getFilterType(SaveData.curFilter)}';
		return 'Filtro de Daltonismo ' + visualValue;
	}
}

class VolumeEfeitos extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Volume dos efeitos do jogo';
	}

	override function right():Bool
	{
        SaveData.volumeEfeitos += 0.1;

        if (SaveData.volumeEfeitos < 0.05)
            SaveData.volumeEfeitos = 0;

        if (SaveData.volumeEfeitos > 0.95)
            SaveData.volumeEfeitos = 1;

		return true;
	}

	override function left():Bool
	{
		SaveData.volumeEfeitos -= 0.1;

        if (SaveData.volumeEfeitos < 0.05)
            SaveData.volumeEfeitos = 0;

        if (SaveData.volumeEfeitos > 0.95)
            SaveData.volumeEfeitos = 1;

		return true;
	}

	override function getValue():String
	{
		var visualValue:String = SaveData.volumeEfeitos == 0 ? 'mutado' : ': ${Std.string(SaveData.volumeEfeitos)}';
		return 'Volume dos efeitos do jogo ' + visualValue;
	}
}

class VolumeMusica extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return 'Volume das musicas de menu';
	}

	override function right():Bool
	{
        SaveData.volumeMusica += 0.1;

        if (SaveData.volumeMusica < 0.05)
            SaveData.volumeMusica = 0;

        if (SaveData.volumeMusica > 0.95)
            SaveData.volumeMusica = 1;

		FlxG.sound.music.volume = SaveData.volumeMusica;

		return true;
	}

	override function left():Bool
	{
		SaveData.volumeMusica -= 0.1;

        if (SaveData.volumeMusica < 0.05)
            SaveData.volumeMusica = 0;

        if (SaveData.volumeMusica > 0.95)
            SaveData.volumeMusica = 1;

		FlxG.sound.music.volume = SaveData.volumeMusica;

		return true;
	}

	override function getValue():String
	{
		var visualValue:String = SaveData.volumeMusica == 0 ? 'mutado' : ': ${Std.string(SaveData.volumeMusica)}';
		return 'Volume das músicas do jogo ' + visualValue;
	}
}