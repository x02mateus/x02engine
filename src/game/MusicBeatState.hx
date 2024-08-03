package game;

import flixel.addons.transition.FlxTransitionableState;
import game.states.Init;
import input.Controls;
import input.PlayerSettings;
#if mobileC
import flixel.input.actions.FlxActionInput;
import input.mobile.ui.FlxVirtualPad;
#end

class MusicBeatState extends flixel.addons.ui.FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	public var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if mobileC
	var _virtualpad:FlxVirtualPad;

	var trackedinputs:Array<FlxActionInput> = [];

	// adding virtualpad to state
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode)
	{
		_virtualpad = new FlxVirtualPad(DPad, Action);
		_virtualpad.alpha = 0.75;
		add(_virtualpad);
		controls.setVirtualPad(_virtualpad, DPad, Action);
		trackedinputs = controls.trackedinputs;
		controls.trackedinputs = [];
	}

	override function destroy()
	{
		controls.removeFlxInput(trackedinputs);

		super.destroy();
	}
	#end

	override function create()
	{
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;

		if (FlxG.sound.music == null)
			MusicManager.playMusic();

		super.create();

		// Custom made Trans out
		if (!skip)
		{
			openSubState(new CustomFadeTransition(1, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		/*var oldStep:Int = curStep;

			updateCurStep();
			updateBeat();

			if (oldStep != curStep && curStep > 0)
				stepHit(); */

		if (Main.getMouseVisibility() && (FlxG.keys.pressed.ANY || GamepadUtil.anyGamepadButtonPressed()))
		{
			if (!Main.isKeyboard && FlxG.keys.pressed.ANY)
				Main.isKeyboard = true;
			else if (Main.isKeyboard && GamepadUtil.anyGamepadButtonPressed())
				Main.isKeyboard = false;

			Main.mouseVisibility(false);
		}
		else if (Main.mouse_allowed && #if !mobile FlxG.mouse.justMoved #else BSLTouchUtils.justTouched() #end)
		{
			Main.mouseVisibility(true);
		}

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.onComplete = function()
			{
				Paths.clear_memory_by_key(MusicManager.curPlaying);
				MusicManager.playMusic();
			};
		}

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		// curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		/*
			var lastChange:BPMChangeEvent = {
				stepTime: 0,
				songTime: 0,
				bpm: 0
			}
			for (i in 0...Song.Conductor.bpmChangeMap.length)
			{
				if (Song.Conductor.songPosition >= Song.Conductor.bpmChangeMap[i].songTime)
					lastChange = Song.Conductor.bpmChangeMap[i];
			}

			curStep = lastChange.stepTime + Math.floor(((Song.Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / Song.Conductor.stepCrochet);
		 */
	}

	public static function switchState(nextState:FlxState)
	{
		// Custom made Trans in

		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if (!FlxTransitionableState.skipNextTransIn)
		{
			leState.openSubState(new CustomFadeTransition(0.7, false));
			if (nextState == FlxG.state)
			{
				CustomFadeTransition.finishCallback = function()
				{
					FlxG.resetState();
				};
				// trace('resetted');
			}
			else
			{
				CustomFadeTransition.finishCallback = function()
				{
					FlxG.switchState(nextState);
				};
				// trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		GlobalSoundManager.changeVolumes();
		FlxG.switchState(nextState);
	}

	public static function resetState()
	{
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState
	{
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
