package Events
{
   import flash.events.Event;
   
   public class RequestEntryFailedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "REQUEST_ENTRY_FAILED";
      
      protected var mErrorCode:uint;
      
      public function RequestEntryFailedEvent(param1:uint, param2:Boolean = false, param3:Boolean = false)
      {
         super("REQUEST_ENTRY_FAILED",param2,param3);
         mErrorCode = param1;
      }
      
      public function get errorCode() : uint
      {
         return mErrorCode;
      }
   }
}

