package Events
{
   import flash.events.Event;
   
   public class ClientExitCompleteEvent extends Event
   {
      
      public static const EVENT_NAME:String = "CLIENT_EXIT_COMPLETE";
      
      public function ClientExitCompleteEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("CLIENT_EXIT_COMPLETE",param1,param2);
      }
   }
}

