package funkin.api;

@:access(funkin.api.GJClient)
class GJData
{
    public static var gjUser:String = '';
    public static var gjToken:String = '';

    public static function saveGJSettings()
    {
        ST.gj().data.gjUser = gjUser;
        ST.gj().data.gjToken = gjToken;
        ST.gj().flush();
    }

    public static function loadGJSettings()
    {
        if(ST.gj().data.gjUser != null) gjUser = ST.gj().data.gjUser;
        if(ST.gj().data.gjToken != null) gjToken = ST.gj().data.gjToken;
    }
}