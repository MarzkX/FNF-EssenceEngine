package funkin;

class Constants
{
     // Game Stuff

     /*
      * A window/application title;
      */
     public static final GAME_TITLE:String = "Friday Night Funkin': Essence Engine";

     /**
      * Game Real Volume
      */
     public static final GAME_REAL_VOLUME:Float = 1.0;

     /**
      * Game Unfocus Volume
      */
     public static final GAME_UNFOCUS_VOLUME:Float = 0.4;

     /**
      * Game FPS Lower
      */
     public static final LOW_FRAME:Int = 20;

     /*
      * Engine version;
      */
     #if !PROTOTYPE
     public static final ENGINE_VERSION:String = "0.1.1";
     #else
     public static final ENGINE_VERSION:String = "0.1.1 [PROTOTYPE]";
     #end

     /**
      * Mod/Engine Web-Page
      */
     #if GAMEJOLT_ALLOWED
     public static final URL_GAME:String = "https://gamejolt.com/games/essence/899093";
     #else
     public static final URL_GAME:String = "https://gamebanana.com/mods/515641";
     #end

     /**
      * Github page
      */
     public static final URL_GITHUB:String = "https://github.com/MarzkX/FNF-EssenceEngine";

     /*
      * FNF Version
      */
     public static final BASE_VERSION:String = "0.2.8";


     // Menu Stuff

     /**
      * Timer of opacity color
      */
     public static final COLOR_TIMER_TWEEN:Float = 0.4;



     // PlayState Stuff

     /*
      * Default first health
      */
     public static final DEFAULT_HEALTH_STAMINA:Float = 1;

     /*
      * Lower health, or died
      */
     public static final LOW_HEALTH_STAMINA:Float = 0;

     /*
      * Higher health
      */
     public static final HIGH_HEALTH_STAMINA:Float = 2;

     /*
      * Players Icon Default Scale
      */
     public static final ICON_DEFAULT_SCALE:Float = 1;

     /*
      * Players Icon Pixel Default Scale
      */
     public static final ICON_PIXEL_DEFAULT_SCALE:Float = 5.5;


     // Funkin Stuff

     /**
      * Original download site
      */
     public static final URL_ITCH:String = 'https://ninja-muffin24.itch.io/funkin/purchase';
}