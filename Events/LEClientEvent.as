package Events
{
   import flash.events.Event;
   
   public class LEClientEvent extends Event
   {
      
      public static const SEND_EVENT:String = "SEND_EVENT";
      
      public var eventName:String = "";
      
      public function LEClientEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super("SEND_EVENT",param2,param3);
         eventName = param1;
      }
   }
}

