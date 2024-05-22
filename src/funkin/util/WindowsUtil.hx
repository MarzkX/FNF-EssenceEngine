package funkin.util;

import lime.system.System;
#if (cpp && windows)
import funkin.cpp.WindowsData;
#end
import lime.graphics.Image;
import openfl.Lib;

class WindowsUtil
{
    public static function getUsername(){
		#if sys
		var envs = Sys.environment();
		// trace(envs);
		if (envs.exists("USERNAME")) return envs["USERNAME"];
		if (envs.exists("USER")) return envs["USER"];
		return '4AwzxX4XZ53C1XZbxzvxzvxzvZ1C2X3ZC12XZcxzczx145dsdC';
		#else
		trace('your system do not reading a system files lol');
		return 'lol';
		#end
	}

	//All variables
	private static var windowTween:FlxTween;

	//Functions
	#if (cpp && windows)
	public static function obtainRAM():Int
	{
		return WindowsData.obtainRAM();
	}

	public static function darkMode()
	{
		WindowsData.setWindowColorMode(DARK);
	}

	public static function lightMode()
	{
		WindowsData.setWindowColorMode(LIGHT);
	}

	public static function setWindowOppacity(a:Float)
	{
		WindowsData.setWindowAlpha(a);
	}

	public static function _setWindowLayered()
	{
		WindowsData._setWindowLayered();
	}
	#end

    public static function restart(?thisResetScore:Bool = false)
	{
		#if sys
		var os = Sys.systemName();
		var args = "Test.hx";
		var app = "";
		var workingdir = Sys.getCwd();

		app = Sys.programPath();

		if(!thisResetScore)
			ST.allSave();

		// Launch application:
		var result = systools.win.Tools.createProcess(app // app. path
			, args // app. args
			, workingdir // app. working directory
			, false // do not hide the window
			, false // do not wait for the application to terminate
		);
		// Show result:
		if (result == 0)
			Sys.exit(1337);
		else
			throw "Failed to restart bich";
		#else
		trace('lel system lox');
		#end
    }

	  /**
   * Runs platform-specific code to open a path in the file explorer.
   * @param targetPath The path to open.
   */
   public static function openFolder(targetPath:String):Void
	{
	  #if CAN_OPEN_LINKS
	  #if windows
	  Sys.command('explorer', [targetPath.replace('/', '\\')]);
	  #elseif mac
	  Sys.command('open', [targetPath]);
	  #elseif linux
	  Sys.command('open', [targetPath]);
	  #end
	  #else
	  throw 'Cannot open URLs on this platform.';
	  #end
	}
  
	/**
	 * Runs platform-specific code to open a file explorer and select a specific file.
	 * @param targetPath The path of the file to select.
	 */
	public static function openSelectFile(targetPath:String):Void
	{
	  #if CAN_OPEN_LINKS
	  #if windows
	  Sys.command('explorer', ['/select,' + targetPath.replace('/', '\\')]);
	  #elseif mac
	  Sys.command('open', ['-R', targetPath]);
	  #elseif linux
	  // TODO: unsure of the linux equivalent to opening a folder and then "selecting" a file.
	  Sys.command('open', [targetPath]);
	  #end
	  #else
	  throw 'Cannot open URLs on this platform.';
	  #end
	}

	public static function exit()
    {
		#if sys
        Sys.exit(0);
		#else
		flash.system.System.exit(0);
		#end
    }

	public static function size(Width:Int, Height:Int)
	{
		FlxG.resizeWindow(Width, Height);
		FlxG.resizeGame(Width, Height);
	}

	public static function icon(path:String)
	{
		var iconImage:Image = Image.fromBitmapData(Paths.image(path).bitmap);
		Lib.application.window.setIcon(iconImage);
	}

	public static function title(t:String)
	{
		if(ClientPrefs.data.appText)
			Lib.application.window.title = Main.appTitle + (
				(t != null || t != '' || t != "") ? (' - ' + t) : '');
		else
			Lib.application.window.title = Main.appTitle;
	}

	public static function tween(Position:Array<Int>, Time:Float, Ease:String)
	{
		if(windowTween != null) {
			windowTween.cancel();
		}

		windowTween = FlxTween.tween(Lib.application.window, 
			{x: Position[0], y: Position[1]}, 
			Time, {ease: Reflect.field(FlxEase, Ease),
			onComplete: function(t:FlxTween)
			{
				t = null;
			}
		});
	}
}