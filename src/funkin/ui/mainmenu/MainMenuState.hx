package funkin.ui.mainmenu;

import funkin.ui.transition.Stickers.StickerSubState;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import engine.states.editors.MasterEditorMenu;
import engine.states.ModsMenuState;
import engine.options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var itemShit:Array<Dynamic> = [
		['story_mode', () -> new StoryMenuState()],
		['freeplay', () -> new FreeplayState()],
		#if ACHIEVEMENTS_ALLOWED ['awards', () -> new AchievementsMenuState()], #end
		['credits', () -> new CreditsState()],
		['options', () -> new OptionsState()],
		#if MODS_ALLOWED ['addons', () -> new ModsMenuState()] #end
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (itemShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80, 0).loadGraphic(PathImage.menu('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(PathImage.menu('menuBGMagenta'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...itemShit.length)
		{
			var offset:Float = 108 - (Math.max(itemShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = PathAtlas.sparrow(PathStr.MENU_MAIN_PATH + itemShit[i][0]);
			menuItem.animation.addByPrefix('idle', itemShit[i][0] + " basic", 24);
			menuItem.animation.addByPrefix('selected', itemShit[i][0] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			if(menuItem.ID == 4)
				menuItem.scale.set(0.95, 0.95);
			menuItems.add(menuItem);
			var scr:Float = (itemShit.length - 4) * 0.135;
			if (itemShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
			menuItem.screenCenter(X);
		}

		var customVer:FlxText = new FlxText(12, FlxG.height - 24, 0, '', 12);
		customVer.scrollFactor.set();
		customVer.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		customVer.text = 'Essence Engine v${Constants.ENGINE_VERSION}';
		add(customVer);

		changeItem(0, false);

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		OptionsState.onPlayState = false;
		if (PlayState.SONG != null)
		{
			PlayState.SONG.arrowSkin = null;
			PlayState.SONG.splashSkin = null;
			PlayState.stageUI = 'normal';
		}

		super.create();

		FlxG.camera.follow(camFollow, null, 9);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		//yes this possible to optimize this code... but imma lazy))))))))))))))))
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(PathSound.file('cancelMenu'));
				state(() -> new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(PathSound.file('confirmMenu'));
				selectedSomethin = true;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, (flick:FlxFlicker) ->
				{
					state(itemShit[curSelected][1]);
				});

				for (i in 0...menuItems.members.length)
				{
					if (i == curSelected)
						continue;
					FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: (twn:FlxTween) ->
						{
							menuItems.members[i].kill();
						}
					});
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				state(() -> new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0, ?playSound = true)
	{
		if(playSound)
			FlxG.sound.play(PathSound.file('scrollMenu'));

		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();
		menuItems.members[curSelected].screenCenter(X);

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();
		menuItems.members[curSelected].screenCenter(X);

		camFollow.setPosition(menuItems.members[curSelected].getGraphicMidpoint().x,
			menuItems.members[curSelected].getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0));
	}
}
