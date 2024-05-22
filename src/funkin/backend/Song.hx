package funkin.backend;

import haxe.Json;
import lime.utils.Assets;

import funkin.backend.Section;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;
	
	@:optional var camMove:Bool;
	@:optional var camPixels:Float;
	@:optional var disableNoteRGB:Bool;
	@:optional var camSmooth:Bool;
	@:optional var camSmoothIntensity:Float;
	@:optional var charTrails:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var events:Array<Dynamic>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var gameOverChar:String;
	public var gameOverSound:String;
	public var gameOverLoop:String;
	public var gameOverEnd:String;
	public var camMove:Bool = false;
	public var camPixels:Float = 0;
	public var disableNoteRGB:Bool = false;
	public var camSmooth:Bool = false;
	public var camSmoothIntensity:Float = 0;
	public var charTrails:Bool = false;
	public var speed:Float = 1;
	public var stage:String;
	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = 'gf';

	private static function onLoadJson(songJson:Dynamic) // Convert old charts to newest format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			songJson.player3 = null;
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}
	}

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);

		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson('chartData/' + formattedFolder + '/' + formattedSong);
		#end
		var path:String = Paths.json('chartData/' + formattedFolder + '/' + formattedSong);

		if(rawJson == null)
			#if MODS_ALLOWED if(FileSystem.exists(moddyFile))
				rawJson = File.getContent(moddyFile).trim();
			else #end
				#if sys rawJson = File.getContent(path).trim(); #else rawJson = Assets.getText(path).trim(); #end

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		if(rawJson != null)
		{
			var songJson:Dynamic = parseJSONshit(rawJson);
			onLoadJson(songJson);
			return songJson;
		}

		return null;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		return cast tjson.TJSON.parse(rawJson).song;
	}
}