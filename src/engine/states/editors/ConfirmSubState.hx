package engine.states.editors;

import flixel.util.FlxSpriteUtil;
import flixel.addons.ui.*;
import flixel.ui.FlxButton;

class ConfirmSubstate extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var finishCallback:Void->Void;
	public function new(finishCallback:Void->Void = null)
	{
		this.finishCallback = finishCallback;
		super();
	}

	var blockInput:Float = 0.1;
	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		bg = new FlxSpriteGroup();
		
		var bg:FlxSprite = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(420, 160, FlxColor.TRANSPARENT), 0, 0, 420, 160, 10, 10, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		var txt:FlxText = new FlxText(0, bg.y + 25, 400, 'There\'s unsaved progress,\nare you sure you want to exit?', 16);
		txt.screenCenter(X);
		txt.alignment = CENTER;
		txt.scrollFactor.set();
		add(txt);

		var btnY = 390;
		var btn:FlxButton = new FlxButton(0, btnY, 'Exit', function() {
			Cursor.hide();
			state(() -> new engine.states.editors.MasterEditorMenu());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			if(finishCallback != null) finishCallback();
		});
		btn.screenCenter(X);
		btn.x -= 100;
		btn.scrollFactor.set();
		add(btn);

		var btn:FlxButton = new FlxButton(0, btnY, 'Cancel', function() close());
		btn.screenCenter(X);
		btn.x += 100;
		btn.scrollFactor.set();
		add(btn);

		FlxG.mouse.visible = true;
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		blockInput = Math.max(0, blockInput - elapsed);
		if(blockInput <= 0 && FlxG.keys.justPressed.ESCAPE)
			close();
	}
}