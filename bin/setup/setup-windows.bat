@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
start https://haxe.org/download/version/4.2.5/
haxelib install lime 8.1.2
haxelib install openfl 9.3.3
haxelib install flixel 5.8.0
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools 1.5.1
haxelib run flixel-tools setup
haxelib install SScript 8.1.6
haxelib install hxCodec 2.5.1
haxelib install tjson 1.4.0
haxelib install yagp 1.1.4
haxelib git systools https://github.com/waneck/systools
haxelib git tentools https://github.com/TentaRJ/tentools
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
haxelib git haxeui-flixel https://github.com/haxeui/haxeui-flixel
haxelib git hxcpp-debug-server https://github.com/FunkinCrew/hxcpp-debugger
haxelib git thx.core https://github.com/FunkinCrew/thx.core
haxelib git thx.semver https://github.com/FunkinCrew/thx.semver
haxelib git flixel-ui https://github.com/MarzkX/flixel-ui essence
haxelib git flixel-addons https://github.com/MarzkX/flixel-addons essence
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib remove linc_luajit
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc
echo Finished!
pause
