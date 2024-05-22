package engine;

import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.typeLimit.NextState;

@:access(flixel.FlxG)
class EssenceFlxG extends FlxG
{
    public static function loading(where:FlxState, tag:String)
    {
        switchState(() -> new Loading(where, tag));
    }

    public static function switchState(nextState:NextState)
    {
        if(nextState == null) nextState = () -> FlxG.state;
		if(nextState.createInstance() == FlxG.state)
		{
			resetState();
			return;
		}

		if(FlxTransitionableState.skipNextTransIn) FlxG.switchState(nextState);
		else startTransition(nextState.createInstance());
		FlxTransitionableState.skipNextTransIn = false;
    }

    public static function resetState() {
		if(FlxTransitionableState.skipNextTransIn) FlxG.resetState();
		else startTransition();
		FlxTransitionableState.skipNextTransIn = false;
	}

	// Custom made Trans in
	public static function startTransition(nextState:FlxState = null)
	{
		if(nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
		if(nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
	}
}