package Events
{
   import flash.events.Event;
   
   public class TrophiesUpdatedAccountEvent extends Event
   {
      
      public static const EVENT_NAME:String = "TrophiesUpdatedAccountEvent";
      
      public var trophyCount:uint;
      
      public function TrophiesUpdatedAccountEvent(param1:uint, param2:Boolean = false, param3:Boolean = false)
      {
         super("TrophiesUpdatedAccountEvent",param2,param3);
         trophyCount = param1;
      }
   }
}

