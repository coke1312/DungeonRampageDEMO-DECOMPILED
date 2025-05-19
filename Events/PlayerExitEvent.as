package Events
{
   import flash.events.Event;
   
   public class PlayerExitEvent extends Event
   {
      
      public static const EVENT_STRING:String = "PlayerExitEvent_str";
      
      public var id:uint;
      
      public function PlayerExitEvent(param1:uint, param2:Boolean = false, param3:Boolean = false)
      {
         id = param1;
         super("PlayerExitEvent_str",param2,param3);
      }
   }
}

