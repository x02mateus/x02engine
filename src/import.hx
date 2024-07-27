import backend.GlobalSoundManager;
import backend.Paths;
import backend.SaveData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import game.MusicBeatState;
import game.MusicBeatSubstate;
import game.substates.transition.CustomFadeTransition;
import haxe.Json;
import lime.utils.Assets;
import sys.FileSystem;
import sys.io.File;
import util.Utils.BSLTouchUtils;
import util.Utils.CamerasUtil;
import util.Utils.CoolUtil;
import util.Utils;

using StringTools;

#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
