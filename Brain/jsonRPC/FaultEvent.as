package Brain.jsonRPC
{
   import flash.events.ErrorEvent;
   
   public class FaultEvent extends ErrorEvent
   {
      
      public static const Fault:String = "fault";
      
      public var fault:Error;
      
      public function FaultEvent(param1:Error)
      {
         this.fault = param1;
         super("fault",true,true,param1.message);
      }
   }
}

