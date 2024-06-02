package engine.options;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', #if GAMEJOLT_ALLOWED 'GameJolt', #end 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new engine.options.NotesSubState());
			#if GAMEJOLT_ALLOWED
			case 'GameJolt':
				state(() -> new engine.states.GameJoltState(onPlayState));
			#end
			case 'Controls':
				openSubState(new engine.options.ControlsSubState());
			case 'Graphics':
				openSubState(new engine.options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new engine.options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new engine.options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				state(() -> new engine.options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		#if GAMEJOLT_ALLOWED
		states.GameJoltState.isOptions = true;
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(PathImage.def_bg());
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			#if GAMEJOLT_ALLOWED
			GameJoltState.isOptions = false;
			#end

			if(onPlayState)
			{
				loading(new PlayState(), 'Game');
				FlxG.sound.music.volume = 0;
			}
			else state(()->new MainMenuState());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}

	var leftTween:FlxTween;
	var rightTween:FlxTween;
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;

				if(leftTween != null)
					leftTween.cancel();
		
				if(rightTween != null)
					rightTween.cancel();

				leftTween = FlxTween.tween(selectorLeft, {x: item.x - 63, y: item.y}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(t:FlxTween)
					{
						t = null;
					}
				});

				rightTween = FlxTween.tween(selectorRight, {x: item.x + item.width + 15, y: item.y}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(t:FlxTween)
					{
						t = null;
					}
				});
			}
		}
		FlxG.sound.play(PathSound.file('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}