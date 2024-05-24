import openfl.Lib;

@:access('openfl.Lib')
class Contains
{
     // Game Stuff

     /*
      * A window/application title;
      */
     public static final GAME_TITLE:String = Lib.application.window.title;

     /*
      * Engine version;
      */
     public static final ENGINE_VERSION:String = Lib.application.meta.get('version');

     /*
      * FNF Version
      */
     public static final BASE_VERSION:String = "0.2.8";

     // PlayState Stuff

     /*
      * Default first health
      */
     public static final DEFAULT_HEALTH_STAMINA:Float = 1;

     /*
      * Lower health, or died
      */
     public staric final LOW_HEALTH_STAMINA:Float = 0;

     /*
      * Higher health
      */
     public static final HIGH_HEALTH_STAMINA:Float = 2;

}