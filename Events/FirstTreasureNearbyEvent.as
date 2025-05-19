package Events
{
   import flash.events.Event;
   
   public class FirstTreasureNearbyEvent extends Event
   {
      
      public static const EVENT_NAME:String = "FirstTreasureNearby";
      
      public function FirstTreasureNearbyEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("FirstTreasureNearby",param1,param2);
      }
   }
}

