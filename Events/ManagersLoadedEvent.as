package Events
{
   import flash.events.Event;
   
   public class ManagersLoadedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "ManagersLoadedEvent";
      
      public function ManagersLoadedEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("ManagersLoadedEvent",param1,param2);
      }
   }
}

