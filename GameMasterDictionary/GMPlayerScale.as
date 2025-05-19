package GameMasterDictionary
{
   import org.as3commons.collections.Map;
   
   public class GMPlayerScale
   {
      
      public static var HPBoostByPlayers:Map = new Map();
      
      public var Players:uint;
      
      public var HPBoost:Number;
      
      public function GMPlayerScale(param1:Object)
      {
         super();
         Players = param1.Players;
         HPBoost = param1.HP_BOOST;
         HPBoostByPlayers.add(Players,HPBoost);
      }
   }
}

