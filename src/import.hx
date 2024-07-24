// FS
import util.Utils;
import lime.utils.Assets;
import sys.FileSystem;
import sys.io.File;

// Som
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import backend.GlobalSoundManager;

// Backend
import backend.SaveData;
import backend.Paths;

// Flixel
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState; // importando o FlxState enquanto eu ainda não converti o MusicBeat
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

// Haxe
import haxe.Json;

// Input
import util.Utils.BSLTouchUtils;

// StringTools
using StringTools;