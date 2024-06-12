package funkinUtil;

@:allow(engine.objects.Character)
class CharUtil impelements Character
{
    public static var char:Character;
    public static var itsAtlas:Bool = false; \\Default

    public function new(who:Character)
    {
        super();
        
        char = who;
    }
    public function idle(?looped=false)
        char.playAnim('idle', looped);

    public function addPose(poses:Array<String>, ?looped=false) {
        if(char != null) {
            for(i in 0...poses.length)
            {
                char.addAnimation(itsAtlas, poses[i], looped);
            }
        }
    }
}