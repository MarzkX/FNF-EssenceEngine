package engine.debug;

import openfl.text.TextFormatAlign;
import openfl.display.Bitmap;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class FPSCounter extends TextField
{
	public var currentFPS(default, null):Int;
	public var memoryMegas(get, never):Float;

	var peak:UInt = 0;
	var deltaTimeout:Float = 0.0;
	final dataTexts = ["B", "KB", "MB", "GB", "TB", "PB"];

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFF000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('vcr.ttf'), 14, color);
		text = "";
		width += 200;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = openfl.Lib.getTimer();
			__enterFrame(time - currentTime);
		});
	}

	var array:Array<FlxColor> = [
		FlxColor.fromRGB(148, 0, 211),
		FlxColor.fromRGB(75, 0, 130),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(255, 127, 0),
		FlxColor.fromRGB(255, 0, 0)
	];

	var skippedFrames = 0;

	public static var currentColor = 0;

	private override function __enterFrame(deltaTime:Float):Void
	{
		if (ClientPrefs.data.fpsRain)
		{
			if (currentColor >= array.length)
				currentColor = 0;
			currentColor = Math.round(FlxMath.lerp(0, array.length, skippedFrames / (ClientPrefs.data.framerate / 3)));
			changeFPSColor(array[currentColor]);
			currentColor++;
			skippedFrames++;
			if (skippedFrames > (ClientPrefs.data.framerate / 3))
				skippedFrames = 0;
		}
		else
		{
			changeFPSColor(FlxColor.WHITE);
		}
		
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		var currentCount = times.length;
		currentFPS = currentCount < FlxG.updateFramerate ? currentCount : FlxG.updateFramerate;
		updateText();

		alpha = ClientPrefs.data.fpsAlpha;

		cacheCount = currentCount;
		deltaTimeout += deltaTime;
	}

	public function changeFPSColor(color:FlxColor)
	{
		textColor = color;
	}

	public function updateText():Void
	{
		if(ClientPrefs.data.showMEM)
		{
			var mem:Dynamic = memoryMegas;
			if (mem > peak)
				peak = mem;
		}

		text = (ClientPrefs.data.showFPS ? 'FPS: $currentFPS' + 
			(ClientPrefs.data.showMEM ? '\nRAM: ' + getSizeLabel(memoryMegas*2) + ' / ${getSizeLabel(peak*2)}' : '') 
			: (ClientPrefs.data.showMEM ? 'RAM: ' + getSizeLabel(memoryMegas*2) + ' / ${getSizeLabel(peak*2)}' : ''));
	}

	function getSizeLabel(num:Float):String
	{
		var size:Float = num;
		var data = 0;
		while (size > 1024 && data < dataTexts.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;

		if (data <= 2)
			size = Math.round(size);

		return size + " " + dataTexts[data];
	}

	inline function get_memoryMegas():Float
		return cast(System.totalMemory, UInt);
}