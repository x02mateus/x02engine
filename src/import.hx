// Backend
import backend.Paths;
import backend.SaveData;
import util.Utils.CoolUtil;

// Haxe
import haxe.Json;

// Flixel
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

// MusicBeat
import game.MusicBeatState;
import game.MusicBeatSubstate;

// Transition
import game.substates.transition.CustomFadeTransition;

// Sons
import backend.GlobalSoundManager;
import backend.MusicManager;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

// FS
import util.Utils;
import lime.utils.Assets;
import sys.FileSystem;
import sys.io.File;

// Input
import util.Utils.BSLTouchUtils;
import util.Utils.BSLSwipeUtils;
import util.Utils.SpriteSwapper;
import util.Utils.GamepadUtil;
import util.Utils.InputDevices;

using StringTools;