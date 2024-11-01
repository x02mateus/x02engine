package game;

import flixel.FlxSubState;
import input.Controls;
import input.PlayerSettings;
#if MOBILE_CONTROLS
import flixel.input.actions.FlxActionInput;
import input.mobile.ui.FlxVirtualPad;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if MOBILE_CONTROLS
	public static var _virtualpad:FlxVirtualPad;

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

		#if android
		controls.addAndroidBack();
		#end
	}

	override function destroy()
	{
		controls.removeFlxInput(trackedinputs);

		super.destroy();
	}
	#end

	override function update(elapsed:Float)
	{
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

		// everyStep();
		/*var oldStep:Int = curStep;

			updateCurStep();
			curBeat = Math.floor(curStep / 4);

			if (oldStep != curStep && curStep > 0)
				stepHit(); */

		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		/*var lastChange:BPMChangeEvent = {
				stepTime: 0,
				songTime: 0,
				bpm: 0
			}
			for (i in 0...Song.Conductor.bpmChangeMap.length)
			{
				if (Song.Conductor.songPosition > Song.Conductor.bpmChangeMap[i].songTime)
					lastChange = Song.Conductor.bpmChangeMap[i];
			}

			curStep = lastChange.stepTime + Math.floor((Song.Conductor.songPosition - lastChange.songTime) / Song.Conductor.stepCrochet); */
	}

	public function stepHit():Void
	{
		/*if (curStep % 4 == 0)
			beatHit(); */
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
