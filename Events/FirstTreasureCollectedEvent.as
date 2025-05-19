package Events
{
   import flash.events.Event;
   
   public class FirstTreasureCollectedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "FirstTreasureCollected";
      
      public function FirstTreasureCollectedEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("FirstTreasureCollected",param1,param2);
      }
   }
}

