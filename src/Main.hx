#if android
import android.content.Context;
#end

import engine.debug.FPSCounter;

import flixel.FlxGame;
import haxe.ui.Toolkit;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

#if linux
import lime.graphics.Image;
#end

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

#if linux
@:cppInclude('./funkin/cpp/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{	
	var gameData = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: funkin.ui.InitState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};
	var game:FlxGame;

	public static var instance:Main;
	public static var fpsVar:FPSCounter;
	public static var appTitle:String = '';

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		instance = this;

		super();

		// Credits to MAJigsaw77 (he's the og author for this code)
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		initHaxeUI();

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (gameData.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / gameData.width;
			var ratioY:Float = stageHeight / gameData.height;
			gameData.zoom = Math.min(ratioX, ratioY);
			gameData.width = Math.ceil(stageWidth / gameData.zoom);
			gameData.height = Math.ceil(stageHeight / gameData.zoom);
		}
	
		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(engine.psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		FlxSprite.defaultAntialiasing = true; //this not pixel game!!
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		appTitle = Lib.application.meta.get('title');

		game = new FlxGame(gameData.width, gameData.height, gameData.initialState, gameData.framerate, 
			gameData.framerate, gameData.skipSplash, gameData.startFullscreen);
		
		@:privateAccess
		game._customSoundTray = funkin.ui.options.FunkinSoundTray;
		
		addChild(game);

		#if !mobile
		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if CRASH_HANDLER
		#if sys Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash); #end
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
		#elseif hl
		hl.Api.setErrorHandler(onError);
		#end
		#end

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {
		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				if (cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			   }
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});

		//idk why this created a crashes
		//lime.app.Application.current.window.onFocusOut.add(onWindowFocusOut);
		//lime.app.Application.current.window.onFocusIn.add(onWindowFocusIn);

		traces();
	}

	var focusMusicTween:FlxTween;
	var oldVol:Float = Constants.GAME_REAL_VOLUME;
	var newVol:Float = Constants.GAME_UNFOCUS_VOLUME;

	public static var focused:Bool = true;

	// thx for ur code ari
	function onWindowFocusOut()
	{
		focused = false;

		// Lower global volume when unfocused
		if (Type.getClass(FlxG.state) != PlayState) // imagine stealing my code smh
		{
			oldVol = FlxG.sound.volume;
			if (oldVol > Constants.GAME_UNFOCUS_VOLUME)
			{
				newVol = Constants.GAME_UNFOCUS_VOLUME;
			}
			else
			{
				if (oldVol > 0.1)
				{
					newVol = 0.1;
				}
				else
				{
					newVol = 0;
				}
			}

			trace("Game unfocused");

			if (focusMusicTween != null)
				focusMusicTween.cancel();
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: newVol}, 0.5);

			// Conserve power by lowering draw framerate when unfocuced
			FlxG.drawFramerate = Constants.LOW_FRAME;
		}
	}

	function onWindowFocusIn()
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			focused = true;
		});

		// Lower global volume when unfocused
		if (Type.getClass(FlxG.state) != PlayState)
		{
			trace("Game focused");

			// Normal global volume when focused
			if (focusMusicTween != null)
				focusMusicTween.cancel();

			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: oldVol}, 0.5);

			// Bring framerate back when focused
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
	}

	function traces() {
		#if MODS_ALLOWED
		trace('MODS_ALLOWED is enabled! The folder \'addons\' will working!');
		#else
		trace('MODS_ALLOWED is disabled! The folder \'addons\' not working!');
		#end

		#if LUA_ALLOWED
		trace('LUA_ALLOWED is enabled! Lua scripts are working!');
		#else
		trace('LUA_ALLOWED is disabled! Lua scripts not working!');
		#end

		#if HSCRIPT_ALLOWED
		trace('HSCRIPT_ALLOWED is enabled! Hxc scripts are working!');
		#else
		trace('HSCRIPT_ALLOWED is disabled! Hxc scripts not working!');
		#end

		#if hxcpp_debug_server
		trace('hxcpp_debug_server is enabled! You can now connect to the game with a debugger.');
		#else
		trace('hxcpp_debug_server is disabled! This build does not support debugging.');
		#end

		#if sys
		trace('you mr. sys (ka)!');
		#else
		trace('you mr. js');
		#end
		
		#if cpp
		trace('you have many codes from C++');
		#else
		trace('you html');
		#end

		#if PROTOTYPE
		trace('THIS PROTOTYPE VERSION');
		#end
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		    sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	#if (cpp || hl)
	private static function onError(message:Dynamic):Void
		throw Std.string(message);
	#end

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		/*
		#if windows
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var errMsg:String = "";
		var txtMsg:String = "";
		var path:String;
		var	appName:String = Lib.application.meta.get('file')+".exe";
		var dateNow:String = Date.now().toString();
		var parentPath = Sys.programPath().substr(0, Sys.programPath().length-appName.length);

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + "-(" + line + ")#";
					txtMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./bin/crashlogs/" + "Flixel_" + dateNow + ".txt";

		if (!FileSystem.exists("./bin/crashlogs/"))
			FileSystem.createDirectory("./bin/crashlogs/");

		File.saveContent(path, txtMsg + "\n");

		var cmd = "cd/D "+parentPath+" && FlixelCrashHandler.exe -"+errMsg+" -"+appName;
		try
		{
			Sys.command(cmd);
		}
		catch(e)
		{
			Sys.println(e);
		}
		Sys.println(txtMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
		#else*/
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./bin/crashlogs/" + "Flixel_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: "+Constants.URL_GITHUB+"\n\n";

		if (!FileSystem.exists("./bin/crashlogs/"))
			FileSystem.createDirectory("./bin/crashlogs/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		lime.app.Application.current.window.alert(errMsg, "Fatal Uncaught Error");
		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
		//#end
		Sys.exit(-1);
	}
	#end

	function initHaxeUI():Void
	{
		// Calling this before any HaxeUI components get used is important:
		// - It initializes the theme styles.
		// - It scans the class path and registers any HaxeUI components.
		Toolkit.init();
		Toolkit.theme = 'dark'; // don't be cringe
		// Toolkit.theme = 'light'; // embrace cringe
		Toolkit.autoScale = false;
		// Don't focus on UI elements when they first appear.
		haxe.ui.focus.FocusManager.instance.autoFocus = false;
		funkin.input.Cursor.registerHaxeUICursors();
		haxe.ui.tooltips.ToolTipManager.defaultDelay = 200;
	}
}
