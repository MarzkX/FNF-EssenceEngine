#if !macro
#if (cpp && LUA_ALLOWED)
import llua.*;
import llua.Lua;
#end

import sys.*;
import sys.io.*;

#if ACHIEVEMENTS_ALLOWED
import funkin.backend.Achievements;
#end
#if DISCORD_ALLOWED
import funkin.api.Discord;
#end
import funkin.ui.awards.*;
import funkin.ui.freeplay.*;
import funkin.ui.mainmenu.*;
import funkin.ui.storymenu.*;
import funkin.ui.title.*;
import funkin.MusicBeatState;
import funkin.MusicBeatSubstate;
import funkin.api.GJApi;
import funkin.api.GJClient;
import funkin.api.GJData;
import funkin.input.Cursor;
import funkin.backend.paths.File as PathFile;
import funkin.backend.paths.Image as PathImage;
import funkin.backend.paths.Sound as PathSound;
import funkin.backend.paths.Music as PathMusic;
import funkin.backend.paths.Atlas as PathAtlas;
import funkin.PathStr;
import funkin.Constants;
import funkin.backend.Paths;
import funkin.backend.Controls;
import funkin.backend.Conductor;
import funkin.util.SaveUtil as ST;
import funkin.backend.Difficulty;
import funkin.ui.PlayState;
import funkin.ui.transition.Loading;
import funkin.util.WindowsUtil as App;

import engine.shaders.PixelSplashShader;
import engine.backend.BaseStage;
import engine.backend.Mods;
import engine.objects.Alphabet;
import engine.objects.BGSprite;
import engine.states.editors.MasterEditorMenu;
import engine.backend.CoolUtil;
import engine.backend.CustomFadeTransition;
import engine.backend.ClientPrefs;
import engine.EssenceFlxG;

#if flxanimate
import flxanimate.*;
#end

//Flixel
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;
#end
