package funkin.api;

import funkin.ui.GameJoltState;
import funkin.api.GJApi as GJKeys;
import flixel.util.typeLimit.OneOfTwo;
import haxe.Http;
import haxe.Json;
import haxe.Timer;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;
import lime.app.Application;
import lime.app.Future;
import lime.app.Promise;
#if sys
import sys.thread.Thread;
#end
import tentools.api.FlxGameJolt as GJApi;

using StringTools;

class GJClient {
	public static var userLogin:Bool = false;
	public static var totalTrophies:Float = GJApi.TROPHIES_ACHIEVED + GJApi.TROPHIES_MISSING;

	public static function getUserInfo(username:Bool = true):String
	{
		if (username)
			return GJApi.username;
		else
			return GJApi.usertoken;
	}

	public static function getStatus():Bool
	{
		return userLogin;
	}

	public static function connect()
	{
		trace("Grabbing API keys...");
		GJApi.init(Std.int(GJKeys.id), Std.string(GJKeys.key), false);
	}

	public static function authDaUser(in1, in2, ?loginArg:Bool = false)
	{
		if (!userLogin)
		{
			GJApi.authUser(in1, in2, function(v:Bool)
			{
				trace("user: " + (in1 == "" ? "n/a" : in1));
				trace("token: " + in2);
				if (v)
				{
					trace("User authenticated!");
					GJData.gjUser = in1;
					GJData.gjToken = in2;
					GJData.saveGJSettings();
					userLogin = true;
					startSession();
					if (loginArg)
					{
						GameJoltState.logged = true;
						EssenceFlxG.switchState(() -> new GameJoltState());
					}
				}
				else
				{
					if (loginArg)
					{
						GameJoltState.logged = true;
						EssenceFlxG.switchState(() -> new GameJoltState());
					}
					trace("User login failure!");
				}
			});
		}
	}

	public static function deAuthDaUser()
	{
		closeSession();
		userLogin = false;
		trace(GJData.gjUser + GJData.gjToken);
		GJData.gjUser = '';
		GJData.gjToken = '';
		GJData.saveGJSettings();
		trace(GJData.gjUser + GJData.gjToken);
		trace("Logged out!");
		
		#if sys
		funkin.util.WindowsUtil.restart();
		#end
	}

	public static function getTrophy(trophyID:Int)
	{
		if (userLogin)
		{
			GJApi.addTrophy(trophyID);
		}
	}

	/**
	 * 
	 * This function checks the data that we got back from GameJolt,
	 * if it says that the trophy is already unlocked,
	 * check if the trophy is unlocked IN THE GAME.
	 * 
	 * If it isn't, then unlock it.
	 * 
	 * NOTE: For this function to work, the Tenta's GameJolt API has to be modified.
	 * You must make the 'returnMap' variable available. A example: https://imgur.com/a/wj0ARTa
	 * 
	 * @param	trophyID	The ID of the trophy on GameJolt.
	 * 
	 */
	/*
		public static function checkTrophy(trophyID:Int)
		{
			GJApi.fetchTrophy(trophyID, function(returnMap)
			{
				var title:String = "";

				@:privateAccess
				{
					var trophies:String = GJApi.returnMap.get('trophies').toString();
					var data:String = 
					title = data;
				}

				@:privateAccess
				if (GJApi.returnMap.exists('message'))
				{
					var data:String = GJApi.returnMap.get('message').toString();
					if (data.contains('already'))
					{
						trace('unlocking alioIYOIWUYBCDOIWTBRCOIWBT');
						Achievements.unlockAchievement(title, true);
					}
				}

				@:privateAccess
				if (GJApi.returnMap.exists('achieved'))
				{
					var data:String = GJApi.returnMap.get('achieved').toString();
					if (data.contains('true'))
					{
						trace('synced from gj!');
						Achievements.unlockAchievement(title, true);
					}
				}
			});
		}
	 */
	public static function startSession()
	{
		GJApi.openSession(function()
		{
			trace("Session started!");
			new FlxTimer().start(20, function(tmr:FlxTimer)
			{
				pingSession();
			}, 0);
		});
	}

	public static function pingSession()
	{
		GJApi.pingSession(true, function()
		{
			trace("Ping!");
		});
	}

	public static function closeSession()
	{
		GJApi.closeSession(function()
		{
			trace('Closed out the session');
		});
	}
}