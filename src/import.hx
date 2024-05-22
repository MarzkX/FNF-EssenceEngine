#if !macro
//Discord API
#if DISCORD_ALLOWED
import funkin.api.Discord;
#end

//Psych
#if (cpp && LUA_ALLOWED)
import llua.*;
import llua.Lua;
#end

#if ACHIEVEMENTS_ALLOWED
import funkin.backend.Achievements;
#end

import sys.*;
import sys.io.*;

import funkin.api.GJApi;
import funkin.api.GJClient;
import funkin.api.GJData;
import funkin.input.Cursor;

import funkin.backend.Paths;
import funkin.backend.Controls;
import engine.backend.CoolUtil;
import engine.backend.CustomFadeTransition;
import engine.backend.ClientPrefs;
import funkin.backend.Conductor;
import engine.backend.BaseStage;
import funkin.util.SaveUtil as ST;
import funkin.backend.Difficulty;
import engine.backend.Mods;

import engine.objects.Alphabet;
import engine.objects.BGSprite;

import funkin.ui.PlayState;
import funkin.ui.transition.Loading;
import engine.states.editors.MasterEditorMenu;

import engine.EssenceFlxG;

#if flxanimate
import flxanimate.*;
#end

import funkin.ui.awards.*;
import funkin.ui.freeplay.*;
import funkin.ui.mainmenu.*;
import funkin.ui.storymenu.*;
import funkin.MusicBeatState;
import funkin.MusicBeatSubstate;

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
