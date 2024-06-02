package engine.objects;

import openfl.utils.Assets;
import haxe.Json;

typedef MenuCharacterFile = {
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var colors:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
	var flipX:Bool;
}

class MenuCharacter extends FlxSprite
{
	var colorTween:FlxTween;
	public var character:String;
	public var hasConfirmAnimation:Bool = false;
	private var DEFAULT_COLORS:Array<Int> = [249, 207, 81];
	public var rgbColors:Array<Int> = [];
	private static var DEFAULT_CHARACTER:String = 'bf';
	var characterPath:String;
	var rawJson = null;
	var charFile:MenuCharacterFile;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		characterPath = 'data/jsonData/storymenu/' + character + '.json';

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(characterPath);
		if (!FileSystem.exists(path)) {
			path = Paths.getSharedPath(characterPath);
		}

		if(!FileSystem.exists(path)) {
			path = Paths.getSharedPath('data/jsonData/storymenu/' + DEFAULT_CHARACTER + '.json');
		}
		rawJson = File.getContent(path);

		#else
		var path:String = Paths.getSharedPath(characterPath);
		if(!Assets.exists(path)) {
			path = Paths.getSharedPath('data/jsonData/storymenu/' + DEFAULT_CHARACTER + '.json');
		}
		rawJson = Assets.getText(path);
		#end

		charFile = cast Json.parse(rawJson);

		rgbColors = charFile.colors;
		color = FlxColor.fromRGB(rgbColors[0], rgbColors[1], rgbColors[2]);

		antialiasing = ClientPrefs.data.antialiasing;

		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == null) character = '';
		if(character == this.character) return;

		this.character = character;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		hasConfirmAnimation = false;
		switch(character) {
			case '':
				visible = false;
				dontPlayAnim = true;

				color = FlxColor.fromRGB(DEFAULT_COLORS[0], DEFAULT_COLORS[1], DEFAULT_COLORS[2]);
			default:
				characterPath = 'data/jsonData/storymenu/' + character + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getSharedPath(characterPath);
				}
		
				if(!FileSystem.exists(path)) {
					path = Paths.getSharedPath('data/jsonData/storymenu/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = File.getContent(path);
		
				#else
				var path:String = Paths.getSharedPath(characterPath);
				if(!Assets.exists(path)) {
					path = Paths.getSharedPath('data/jsonData/storymenu/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = Assets.getText(path);
				#end

				charFile = cast Json.parse(rawJson);

				frames = PathAtlas.sparrow(PathStr.MENU_STORY_PATH + 'characters/' + charFile.image);
				animation.addByPrefix('idle', charFile.idle_anim, 24);

				var confirmAnim:String = charFile.confirm_anim;
				if(confirmAnim != null && confirmAnim.length > 0 && confirmAnim != charFile.idle_anim)
				{
					animation.addByPrefix('confirm', confirmAnim, 24, false);
					if (animation.getByName('confirm') != null) //check for invalid animation
						hasConfirmAnimation = true;
				}

				flipX = (charFile.flipX == true);
				rgbColors = charFile.colors;

				if(colorTween != null)
					colorTween.cancel();

				colorTween = FlxTween.color(this, Constants.COLOR_TIMER_TWEEN, this.color, FlxColor.fromRGB(rgbColors[0], rgbColors[1], rgbColors[2]), {
					onComplete: (t:FlxTween) -> {
						t = null;
					}
				});

				if(charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					updateHitbox();
				}
				offset.set(charFile.position[0], charFile.position[1]);
				animation.play('idle');
		}
	}
}
