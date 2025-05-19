package Events
{
   import flash.events.Event;
   
   public class BoostersParsedEvent extends Event
   {
      
      public static const BOOSTERS_PARSED_UPDATE:String = "BoostersParsedEvent_BOOSTERS_PARSED_UPDATE";
      
      public function BoostersParsedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

