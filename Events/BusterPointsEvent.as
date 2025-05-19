package Events
{
   public class BusterPointsEvent extends GameObjectEvent
   {
      
      public static const BUSTER_POINTS_UPDATE:String = "BusterPointEvent_BUSTER_POINTS_UPDATE";
      
      public var busterPoints:uint;
      
      public var maxBusterPoints:uint;
      
      public function BusterPointsEvent(param1:String, param2:uint, param3:uint, param4:uint, param5:Boolean = false, param6:Boolean = false)
      {
         this.busterPoints = param3;
         this.maxBusterPoints = param4;
         super(param1,param2,param5,param6);
      }
   }
}

